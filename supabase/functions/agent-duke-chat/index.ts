import OpenAI from "npm:openai";

const openai = new OpenAI({
  apiKey: Deno.env.get("OPENAI_API_KEY"),
});

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SUPABASE_ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY") ?? "";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

async function callAppFunction(
  name: string,
  authorization: string,
  body?: Record<string, unknown>,
) {
  try {
    const response = await fetch(
      `${SUPABASE_URL}/functions/v1/${name}`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "apikey": SUPABASE_ANON_KEY,
          "Authorization": authorization || `Bearer ${SUPABASE_ANON_KEY}`,
        },
        body: JSON.stringify(body ?? {}),
      },
    );

    const text = await response.text();

    let data: unknown = text;

    try {
      data = JSON.parse(text);
    } catch (_) {}

    return {
      ok: response.ok,
      status: response.status,
      data,
    };
  } catch (error) {
    return {
      ok: false,
      status: 0,
      error: String(error),
    };
  }
}

function wantsSEO(message: string) {
  const m = message.toLowerCase();

  return [
    "seo",
    "search console",
    "google search",
    "impressions",
    "clicks",
    "ctr",
    "position",
    "keyword",
    "keywords",
    "website traffic",
    "website performance",
    "organic",
  ].some((word) => m.includes(word));
}

function wantsAds(message: string) {
  const m = message.toLowerCase();

  return [
    "google ads",
    "ads",
    "campaign",
    "campaigns",
    "ad spend",
    "cost per click",
    "cpc",
    "conversions",
    "advertising",
  ].some((word) => m.includes(word));
}

function wantsWholeApp(message: string) {
  const m = message.toLowerCase();

  return [
    "whole app",
    "entire app",
    "check everything",
    "check the app",
    "company health",
    "business health",
    "what needs attention",
    "what should we work on",
    "how are we doing",
    "overview",
  ].some((word) => m.includes(word));
}


function wantsWordPressDraft(message: string) {
  const m = message.toLowerCase();

  return (
    ["blog", "article", "wordpress", "post", "draft"].some(x => m.includes(x)) &&
    ["save", "create", "make", "send"].some(x => m.includes(x))
  );
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { message } = await req.json();

    if (!message || typeof message !== "string") {
      return new Response(
        JSON.stringify({ error: "Message is required." }),
        {
          status: 400,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    const authorization =
      req.headers.get("authorization") ??
      `Bearer ${SUPABASE_ANON_KEY}`;

    
if (wantsWordPressDraft(message)) {
  const articleResponse = await openai.responses.create({
    model: "gpt-5.6",
    instructions: `
Create a complete SEO blog article for Jiffy Roadside Assistance.

Return ONLY valid JSON:
{
  "query": "primary SEO keyword",
  "title": "SEO optimized title",
  "meta": "meta description under 160 characters",
  "content": "complete WordPress-ready HTML article"
}

Requirements:
- Useful natural writing
- Clear H2 and H3 headings
- Mention relevant roadside services naturally
- Strong call to action
- Link readers to https://jiffyroadsideassistance.com
- Do not invent prices, guarantees, service areas, or business facts
`,
    input: message,
  });

  let raw = articleResponse.output_text.trim();

  raw = raw
    .replace(/^\`\`\`json\s*/i, "")
    .replace(/^\`\`\`\s*/i, "")
    .replace(/\s*\`\`\`$/i, "")
    .trim();

  const firstBrace = raw.indexOf("{");
  const lastBrace = raw.lastIndexOf("}");

  if (firstBrace >= 0 && lastBrace > firstBrace) {
    raw = raw.slice(firstBrace, lastBrace + 1);
  }

  const article = JSON.parse(raw);

  const wpResult = await callAppFunction(
    "wordpress-seo",
    authorization,
    {
      action: "create_seo_draft",
      query: String(article.query ?? article.title ?? "roadside assistance"),
      title: String(article.title ?? "Jiffy Roadside Assistance"),
      meta: String(article.meta ?? ""),
      content: String(article.content ?? ""),
    },
  );

  if (!wpResult.ok) {
    return new Response(
      JSON.stringify({
        reply:
          "I created the article, but WordPress could not save the draft. " +
          JSON.stringify(wpResult.data ?? wpResult.error),
        agent: "Agent Duke the Boss",
      }),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  }

  const wpData =
    wpResult.data && typeof wpResult.data === "object"
      ? wpResult.data as Record<string, unknown>
      : {};

  return new Response(
    JSON.stringify({
      reply:
        "WordPress draft created successfully.\n\n" +
        "Title: " + String(wpData.title ?? article.title) + "\n" +
        "Post ID: " + String(wpData.id ?? "created") + "\n" +
        "Status: " + String(wpData.status ?? "draft"),
      agent: "Agent Duke the Boss",
      wordpress: wpResult.data,
    }),
    {
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json",
      },
    },
  );
}

const appContext: Record<string, unknown> = {};

    const fullScan = wantsWholeApp(message);

    if (fullScan || wantsSEO(message)) {
      appContext.google_search_console =
        await callAppFunction(
          "google-search-console",
          authorization,
        );
    }

    if (fullScan || wantsAds(message)) {
      appContext.google_ads =
        await callAppFunction(
          "google-ads-sync",
          authorization,
        );
    }

    const response = await openai.responses.create({
      model: "gpt-5.6",

      instructions: `
You are Agent Duke the Boss, the central AI operating agent inside
999 Lead Intelligence.

You are not merely a chatbot.

You are the intelligence layer for the application.

CONNECTED SYSTEMS CURRENTLY AVAILABLE:
- Google Search Console
- SEO intelligence
- Google Ads
- Lead Intelligence AI
- Dashboard/application information supplied to you
- Additional systems will be added as they are built

RULES:

1. When live application data is included in APP DATA, use it.
2. Never say you cannot access Search Console or Google Ads when
   that information is present in APP DATA.
3. Never invent metrics.
4. Clearly distinguish live data from recommendations.
5. If a connected system returns an error, explain which system
   failed instead of pretending no access exists.
6. Analyze performance, identify problems, identify opportunities,
   and recommend specific next actions.
7. When asked to check the whole app, provide an executive health
   report using every connected source supplied.
8. Do not claim CRM records exist if the CRM has not been built yet.
9. Do not claim you performed destructive or external actions unless
   a connected tool actually performed them.
10. Be concise, practical, confident, and action-oriented.

You are Agent Duke the Boss.
`,

      input: `
USER REQUEST:
${message}

LIVE 999 LEAD INTELLIGENCE APP DATA:
${JSON.stringify(appContext, null, 2)}
`,
    });

    return new Response(
      JSON.stringify({
        reply: response.output_text,
        agent: "Agent Duke the Boss",
        systems_checked: Object.keys(appContext),
      }),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  } catch (error) {
    console.error("Agent Duke error:", error);

    return new Response(
      JSON.stringify({
        error:
          error instanceof Error
            ? error.message
            : "Agent Duke could not complete the request.",
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
