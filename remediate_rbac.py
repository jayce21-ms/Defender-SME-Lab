import asyncio
from copilot import CopilotClient

async def main():
    client = CopilotClient()
    await client.start()
    
    session = await client.create_session({"model": "gpt-5-agent"})
    
    print("🤖 Agentic MPF is scanning for the last deployment failure...")
    prompt = "Find the last RBAC failure in my subscription and use the MPF skill to suggest a Bicep fix."
    
    response = await session.send_and_wait({"prompt": prompt})
    print("\n--- Agent Remediation ---")
    print(response.data.content)
    
    await client.stop()

if __name__ == "__main__":
    asyncio.run(main())
