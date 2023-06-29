SELECT
  OACT."AcctCode",
  OACT."AcctName",
  OACT."Levels",
  OACT."GroupMask",
  LENGTH(OACT."AcctCode") AS "Digitos",
  CASE
    WHEN JDT1."Saldo" IS NULL THEN 0
    ELSE JDT1."Saldo"
  END AS "Saldo"
FROM OACT
  LEFT JOIN (
    SELECT "Account",
      SUM("Credit" - "Debit") AS "Saldo"
    FROM JDT1
WHERE 
  "RefDate" >= '2023-01-01' AND
  "RefDate" <= '2023-12-31'
    GROUP BY "Account"
  ) JDT1 ON OACT."AcctCode" = JDT1."Account"
WHERE
  OACT."GroupMask" IN (1,2,3,4,5,6,7)
ORDER BY (
CASE WHEN OACT."GroupMask" = 1 THEN 1
 WHEN OACT."GroupMask" = 2 THEN 3
 WHEN OACT."GroupMask" = 3 THEN 4
 WHEN OACT."GroupMask" = 4 THEN 6
 WHEN OACT."GroupMask" = 5 THEN 7
 WHEN OACT."GroupMask" = 6 THEN 2
 WHEN OACT."GroupMask" = 7 THEN 5
ELSE 0 END) ASC, OACT."AcctCode"