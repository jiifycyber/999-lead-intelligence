const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const apiKey = Deno.env.get("OPENAI_API_KEY");

    if (!apiKey) {
      return new Response(
        JSON.stringify({
          error: "OPENAI_API_KEY is not configured",
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

    const body = await req.json();

    const {
      name = "",
      phone = "",
      email = "",
      source = "unknown",
      status = "new",
      score = 0,
    } = body;

    if (!name) {
      return new Response(
        JSON.stringify({
          error: "Lead name is required",
        }),
        {
          status: 400,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    const prompt = `
You are the AI intelligence engine for 999 Lead Intelligence.

Analyze this sales lead and determine the best next action.

LEAD
Name: ${name}
Phone available: ${phone ? "yes" : "no"}
Email available: ${email ? "yes" : "no"}
Source: ${source}
Current status: ${status}
Current score: ${score}

Return ONLY valid JSON using this exact structure:

{
  "priority": "hot | warm | cold",
  "recommended_score": 0,
  "next_action": "",
  "reason": "",
  "contact_method": "call | sms | email | none",
  "follow_up_timing": "",
  "sales_message": ""
}

Rules:
- recommended_score must be an integer from 0 to 100.
- Prioritize leads with stronger intent and usable contact information.
- Do not invent facts about the lead.
- sales_message should be short and professional.
- If there is not enough information, say so in the reason.
`;

    const openaiResponse = await fetch(
      "https://api.openai.com/v1/responses",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${apiKey}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: "gpt-5",
          input: prompt,
        }),
      },
    );

    const data = await openaiResponse.json();

    if (!openaiResponse.ok) {
      console.error("OpenAI error:", data);

      return new Response(
        JSON.stringify({
          error: "AI request failed",
          details: data,
        }),
        {
          status: openaiResponse.status,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    const outputText =
      data.output_text ??
      data.output?.[0]?.content?.[0]?.text ??
      "";

    let intelligence;

    try {
      intelligence = JSON.parse(outputText);
    } catch {
      intelligence = {
        priority: "warm",
        recommended_score: score,
        next_action: outputText || "Review lead manually.",
        reason: "AI returned an unstructured response.",
        contact_method: phone ? "call" : email ? "email" : "none",
        follow_up_timing: "As soon as practical",
        sales_message: "",
      };
    }

    return new Response(
      JSON.stringify({
        success: true,
        lead: {
          name,
          source,
          status,
          score,
        },
        intelligence,
      }),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  } catch (error) {
    console.error(error);

    return new Response(
      JSON.stringify({
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
