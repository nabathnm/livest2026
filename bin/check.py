import re
with open(r"d:\vs code\flutterProject\livest2026\lib\features\buyer\home\pages\home_page.dart", "r") as f:
    code = f.read()

def balance(text):
    opens = {'{':'}', '[':']', '(':')'}
    closes = {v:k for k,v in opens.items()}
    stack = []
    lines = text.split('\n')
    for i, line in enumerate(lines[:248]):
        for j, char in enumerate(line):
            if char in opens:
                stack.append((char, i, j))
            elif char in closes:
                if not stack:
                    print(f"Unmatched closing {char} at line {i+1}")
                    return False
                top, ti, tj = stack.pop()
                if opens[top] != char:
                    print(f"Mismatch at line {i+1}: expected {opens[top]} but found {char}")
                    return False
    
    if stack:
        print(f"Unmatched opens: {stack}")
        return False
    return True

balance(code)
