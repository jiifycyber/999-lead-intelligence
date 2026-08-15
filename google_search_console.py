from googleapiclient.discovery import build
from google.oauth2.credentials import Credentials
from datetime import date, timedelta

SEARCH_CONSOLE_SCOPE = "https://www.googleapis.com/auth/webmasters.readonly"


def build_search_console_service(
    access_token,
    refresh_token=None,
    client_id=None,
    client_secret=None,
):
    creds = Credentials(
        token=access_token,
        refresh_token=refresh_token,
        token_uri="https://oauth2.googleapis.com/token",
        client_id=client_id,
        client_secret=client_secret,
        scopes=[SEARCH_CONSOLE_SCOPE],
    )

    return build("searchconsole", "v1", credentials=creds)


def list_sites(service):
    result = service.sites().list().execute()
    return result.get("siteEntry", [])


def search_performance(service, site_url, days=28):
    end_date = date.today() - timedelta(days=2)
    start_date = end_date - timedelta(days=days - 1)

    body = {
        "startDate": start_date.isoformat(),
        "endDate": end_date.isoformat(),
        "dimensions": ["query", "page"],
        "rowLimit": 1000,
    }

    result = (
        service.searchanalytics()
        .query(siteUrl=site_url, body=body)
        .execute()
    )

    rows = []

    for row in result.get("rows", []):
        keys = row.get("keys", [])

        rows.append({
            "query": keys[0] if len(keys) > 0 else "",
            "page": keys[1] if len(keys) > 1 else "",
            "clicks": row.get("clicks", 0),
            "impressions": row.get("impressions", 0),
            "ctr": row.get("ctr", 0),
            "position": row.get("position", 0),
        })

    return rows
