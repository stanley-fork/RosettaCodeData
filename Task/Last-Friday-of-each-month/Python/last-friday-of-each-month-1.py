"""Last Friday of each month. Requires Python >= 3.9.

https://rosettacode.org/wiki/Last_Friday_of_each_month#Python
"""

from calendar import monthrange
from datetime import date
from datetime import timedelta
from typing import Iterator

def last_fridays(year: int) -> Iterator[date]:
    for month in range(1, 13):
        last_day = date(year, month, monthrange(year, month)[1])
        yield last_day - timedelta(days=(last_day.weekday() - 4) % 7)

if __name__ == "__main__":
    for dt in last_fridays(2012):
        print(dt)
