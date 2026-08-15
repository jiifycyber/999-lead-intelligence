const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

function requiredEnv(name: string): string {
  const value = Deno.env.get(name);
  if (!value) throw new Error(`${name} is not configured`);
  return value;
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const clientId = requiredEnv("GOOGLE_ADS_CLIENT_ID");
    const clientSecret = requiredEnv("GOOGLE_ADS_CLIENT_SECRET");
    const refreshToken = requiredEnv("GOOGLE_ADS_REFRESH_TOKEN");
    const developerToken = requiredEnv("GOOGLE_ADS_DEVELOPER_TOKEN");
    const loginCustomerId = requiredEnv("GOOGLE_ADS_LOGIN_CUSTOMER_ID");
    const customerId = requiredEnv("GOOGLE_ADS_CUSTOMER_ID");

    // 1. Exchange refresh token for a fresh OAuth access token.
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
      return new Response(
        JSON.stringify({
          success: false,
          stage: "oauth",
          error: tokenData,
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

    // 2. Query Jiffy's campaign performance.
    const query = "SELECT campaign.id, campaign.name, campaign.status, campaign.advertising_channel_type, metrics.impressions, metrics.clicks, metrics.cost_micros, metrics.conversions, metrics.ctr, metrics.average_cpc FROM campaign WHERE segments.date DURING LAST_30_DAYS ORDER BY metrics.cost_micros DESC";

    const adsResponse = await fetch(
      `https://googleads.googleapis.com/v25/customers/${customerId}/googleAds:searchStream`,
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${tokenData.access_token}`,
          "developer-token": developerToken,
          "login-customer-id": loginCustomerId,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ query }),
      },
    );

    const adsData = await adsResponse.json();

    if (!adsResponse.ok) {
      return new Response(
        JSON.stringify({
          success: false,
          stage: "google_ads",
          error: adsData,
        }),
        {
          status: adsResponse.status,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    const campaigns: Record<string, unknown>[] = [];

    for (const batch of adsData) {
      for (const row of batch.results ?? []) {
        const campaign = row.campaign ?? {};
        const metrics = row.metrics ?? {};

        const costMicros = Number(metrics.costMicros ?? 0);
        const conversions = Number(metrics.conversions ?? 0);

        campaigns.push({
          id: campaign.id,
          name: campaign.name,
          status: campaign.status,
          channel: campaign.advertisingChannelType,
          impressions: Number(metrics.impressions ?? 0),
          clicks: Number(metrics.clicks ?? 0),
          spend: costMicros / 1_000_000,
          conversions,
          ctr: Number(metrics.ctr ?? 0),
          average_cpc:
            Number(metrics.averageCpc ?? 0) / 1_000_000,
          cost_per_conversion:
            conversions > 0
              ? costMicros / 1_000_000 / conversions
              : null,
        });
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        customer_id: customerId,
        period: "LAST_30_DAYS",
        campaign_count: campaigns.length,
        campaigns,
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
