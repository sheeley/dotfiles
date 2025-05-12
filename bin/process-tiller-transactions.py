#!/usr/bin/env python3
# Purpose: Process and analyze financial transactions from Tiller

from csv import DictReader
from decimal import Decimal
from collections import defaultdict

total = Decimal()
count = defaultdict(int)

with open("Tiller Finance Tracker - Transactions.csv", "r") as f:
    r = DictReader(f)
    for row in r:
        if row.get("Category") != "Finance: Transfer":
            continue
        if not row["Date"].endswith("2023"):
            break
        amt = row["Amount"].replace("$", "").replace(",", "")
        amount = Decimal(amt)
        total += amount
        count[amount] += 1
        print(row["Description"], amount, total)

print(count)
