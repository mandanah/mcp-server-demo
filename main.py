from mcp.server.fastmcp import FastMCP

# create a FastMCP instance
mcp = FastMCP(name="Demo", instructions="This is a demo of mcp-server.")


@mcp.tool()
def add(x: int, y: int) -> int:
    """Adds two integers."""
    return x + y


@mcp.resource("health://status")
def health() -> str:
    """Basic liveness check."""
    return "OK"


@mcp.resource("greeting://{name}")
def get_greeting(name: str) -> str:
    "get a personalized greeting for the user"
    return f"Hello, {name}! "


@mcp.prompt()
def greet_user(name: str, style: str = "friendly") -> str:
    """Greets the user in a specified style."""
    styles = {
        "friendly": "Please write a warm, friendly greeting",
        "formal": "Please write a formal, professional greeting",
        "casual": "Please write a casual, relaxed greeting",
    }
    return f"{styles.get(style, styles['friendly'])} for someone named {name}."


def main():
    print("Hello from mcp-server-demo!")
    return mcp.streamable_http_app()


# Create the ASGI app instance for uvicorn
app = main()

if __name__ == "__main__":
    app  # Use the app if running directly
