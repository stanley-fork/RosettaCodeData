import datetime

today = datetime.date.today()

print(today.strftime("%Y-%m-%d"))
# Or using the `isoformat` method of `date`.
print(today.isoformat())

print(today.strftime("%A, %B %d, %Y"))
# Or using a "format specifier" with `str.format` or an f-string.
print("{today:%A, %B %d, %Y}".format(today=today))
print(f"{today:%A, %B %d, %Y}")
