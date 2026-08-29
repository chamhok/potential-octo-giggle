from __future__ import annotations

from pprint import pprint
from gradio_client import Client

for space in ("ACE-Step/Ace-Step-v1.5", "MBLF/ACE-Step-1.5"):
    print("\n=====", space, "=====")
    try:
        client = Client(space, verbose=True)
        api = client.view_api(return_format="dict")
        pprint(api, width=160, sort_dicts=False)
    except Exception as exc:
        print(type(exc).__name__, str(exc))
