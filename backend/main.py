from fastapi import FastAPI
import asyncio
from playwright.async_api import async_playwright

app = FastAPI(title="NGO Verification API")

async def scrape_ngos():
    async with async_playwright() as p:
        # Launch headless Chromium
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        url = "https://ngosindia.org/ngo-profile/ngo-verification/maharashtra/"
        print("Navigating to:", url)
        await page.goto(url, timeout=60000)

        # Wait until network is idle
        await page.wait_for_load_state("networkidle", timeout=60000)

        # Scrape NGO data from table(s)
        tables = await page.query_selector_all("table")
        ngos = []
        if tables:
            print("Found", len(tables), "table(s) on the page.")
            for table in tables:
                rows = await table.query_selector_all("tr")
                if len(rows) > 1:
                    print("Using a table with", len(rows), "rows.")
                    # Skip header row if present
                    for row in rows[1:]:
                        cols = await row.query_selector_all("td")
                        if len(cols) >= 5:
                            unique_id = (await cols[0].inner_text()).strip()
                            ngo_name  = (await cols[1].inner_text()).strip()
                            state     = (await cols[2].inner_text()).strip()
                            address   = (await cols[3].inner_text()).strip()
                            sectors   = (await cols[4].inner_text()).strip()
                            ngos.append({
                                "Unique ID": unique_id,
                                "NGO Name": ngo_name,
                                "State": state,
                                "Address": address,
                                "Sectors": sectors,
                            })
                    if ngos:
                        break
        else:
            print("No table found on the page.")

        if not ngos:
            print("No NGO data extracted. Check the page structure.")
        await browser.close()
        return ngos

@app.get("/scrape-ngos")
async def get_ngos():
    ngos = await scrape_ngos()
    return {"scraped_count": len(ngos), "ngos": ngos}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
