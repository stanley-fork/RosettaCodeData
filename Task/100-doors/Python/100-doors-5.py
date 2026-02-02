for i in range(1, 101):
    print(f"Door {i}:{"closed" if i**0.5 % 1 else "open"}")
