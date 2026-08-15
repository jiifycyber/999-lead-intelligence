const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

function requiredEnv(name: string) {
  const value = Deno.env.get(name);
  if (!value) throw new Error(`Missing ${name}`);
  return value;
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const clientId = requiredEnv("GOOGLE_SEARCH_CONSOLE_CLIENT_ID");
    const clientSecret = requiredEnv("GOOGLE_SEARCH_CONSOLE_CLIENT_SECRET");
    const refreshToken = requiredEnv("GOOGLE_SEARCH_CONSOLE_REFRESH_TOKEN");

    // Exchange Search Console refresh token for a fresh access token
    const tokenResponse = await fetch(
      "https://oauth2.googleapis.com/token",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: new URLSearchParams({
          client_id: clientId,
          client_secret: clientSecret,
          refresh_token: refreshToken,
          grant_type: "refresh_token",
        }),
      },
    );

    const tokenData = await tokenResponse.json();

    if (!tokenResponse.ok || !tokenData.access_token) {
      throw new Error(
        `Google OAuth failed: ${JSON.stringify(tokenData)}`,
      );
    }

    const accessToken = tokenData.access_token;

    // If no siteUrl is supplied, return all Search Console properties.
    const url = new URL(req.url);
    const siteUrl = url.searchParams.get("siteUrl");

    if (!siteUrl) {
      const sitesResponse = await fetch(
        "https://www.googleapis.com/webmasters/v3/sites",
        {
          headers: {
            Authorization: `Bearer ${accessToken}`,
          },
        },
      );

      const sitesData = await sitesResponse.json();

      if (!sitesResponse.ok) {
        throw new Error(
          `Search Console sites request failed: ${JSON.stringify(sitesData)}`,
        );
      }

      return new Response(
        JSON.stringify({
          success: true,
          mode: "sites",
          sites: sitesData.siteEntry ?? [],
        }),
        {
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    const endDate = new Date();
    endDate.setUTCDate(endDate.getUTCDate() - 2);

    const startDate = new Date(endDate);
    startDate.setUTCDate(startDate.getUTCDate() - 27);

    const iso = (d: Date) => d.toISOString().slice(0, 10);

    const performanceResponse = await fetch(
      `https://www.googleapis.com/webmasters/v3/sites/${encodeURIComponent(siteUrl)}/searchAnalytics/query`,
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          startDate: iso(startDate),
          endDate: iso(endDate),
          dimensions: ["query", "page"],
          rowLimit: 1000,
        }),
      },
    );

    const performanceData = await performanceResponse.json();

    if (!performanceResponse.ok) {
      throw new Error(
        `Search Analytics request failed: ${JSON.stringify(performanceData)}`,
      );
    }

    const rows = (performanceData.rows ?? []).map((row: any) => ({
      query: row.keys?.[0] ?? "",
      page: row.keys?.[1] ?? "",
      clicks: row.clicks ?? 0,
      impressions: row.impressions ?? 0,
      ctr: row.ctr ?? 0,
      position: row.position ?? 0,
    }));

    return new Response(
      JSON.stringify({
        success: true,
        mode: "performance",
        site_url: siteUrl,
        period: "LAST_28_DAYS",
        row_count: rows.length,
        rows,
      }),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  } catch (error) {
    return new Response(
      JSON.stringify({
        success: false,
        error: error instanceof Error ? error.message : "Unknown error",
      }),
      {
        status: 500,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  }
});
