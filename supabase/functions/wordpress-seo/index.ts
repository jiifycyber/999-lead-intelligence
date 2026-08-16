Deno.serve(async (req) => {
  const corsHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers":
        "authorization, x-client-info, apikey, content-type",
  };

  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const WP_URL = Deno.env.get("WORDPRESS_URL") ?? "";
    const WP_USERNAME = Deno.env.get("WORDPRESS_USERNAME") ?? "";
    const WP_APP_PASSWORD =
        (Deno.env.get("WORDPRESS_APP_PASSWORD") ?? "")
            .replaceAll(" ", "");

    if (!WP_URL || !WP_USERNAME || !WP_APP_PASSWORD) {
      throw new Error("WordPress server configuration missing");
    }

    const body = await req.json();

    const action = body.action ?? "create_seo_draft";

    const auth = btoa(
      `${WP_USERNAME}:${WP_APP_PASSWORD}`,
    );

    const headers = {
      "Authorization": `Basic ${auth}`,
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    if (action === "test") {
      const response = await fetch(
        `${WP_URL.replace(/\/$/, "")}/wp-json/wp/v2/users/me?context=edit`,
        { headers },
      );

      const data = await response.json();

      if (!response.ok) {
        return new Response(
          JSON.stringify({
            success: false,
            error: data,
          }),
          {
            status: response.status,
            headers: {
              ...corsHeaders,
              "Content-Type": "application/json",
            },
          },
        );
      }

      return new Response(
        JSON.stringify({
          success: true,
          user: data.name,
          userId: data.id,
        }),
        {
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    if (action === "create_seo_draft") {
      const query = String(body.query ?? "").trim();
      const title = String(body.title ?? "").trim();
      const meta = String(body.meta ?? "").trim();

      if (!query || !title) {
        throw new Error("query and title are required");
      }

      const content = `
<h1>${escapeHtml(query)}</h1>

<p>Jiffy Roadside Assistance provides fast, dependable roadside assistance for drivers who need ${escapeHtml(query)}.</p>

<h2>Roadside Assistance Services</h2>
<ul>
  <li>Jump starts and battery assistance</li>
  <li>Flat tire changes</li>
  <li>Vehicle lockout assistance</li>
  <li>Fuel delivery</li>
</ul>

<h2>Fast Local Roadside Help</h2>
<p>When you need roadside assistance, Jiffy Roadside Assistance is ready to help you get back on the road.</p>

<h2>Frequently Asked Questions</h2>

<h3>How quickly can roadside assistance arrive?</h3>
<p>Response time depends on your location, traffic, technician availability, and service requested.</p>

<h3>What roadside services are available?</h3>
<p>Services may include jump starts, tire changes, lockouts, fuel delivery, and other roadside assistance.</p>

<p><strong>Need help now?</strong> Contact Jiffy Roadside Assistance to request service.</p>
      `.trim();

      const response = await fetch(
        `${WP_URL.replace(/\/$/, "")}/wp-json/wp/v2/posts`,
        {
          method: "POST",
          headers,
          body: JSON.stringify({
            title,
            content,
            excerpt: meta,
            status: "draft",
          }),
        },
      );

      const data = await response.json();

      if (!response.ok) {
        return new Response(
          JSON.stringify({
            success: false,
            error: data,
          }),
          {
            status: response.status,
            headers: {
              ...corsHeaders,
              "Content-Type": "application/json",
            },
          },
        );
      }

      return new Response(
        JSON.stringify({
          success: true,
          id: data.id,
          status: data.status,
          link: data.link,
          title: data.title?.rendered ?? title,
        }),
        {
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    throw new Error(`Unknown action: ${action}`);
  } catch (error) {
    return new Response(
      JSON.stringify({
        success: false,
        error: error instanceof Error
            ? error.message
            : String(error),
      }),
      {
        status: 400,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Content-Type": "application/json",
        },
      },
    );
  }
});

function escapeHtml(value: string) {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}
