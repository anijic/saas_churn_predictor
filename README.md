# SaaS Revenue Protection System (Risk Engine)

### [🔴 Interact with the Live Control Panel (Tableau Public)](https://public.tableau.com/views/SaaSRetentionCommandCenter/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link)

[![SaaS Retention Command Center](SaaS%20Retention%20Command%20Center.png)](https://public.tableau.com/views/SaaSRetentionCommandCenter/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link)

*Click the image above to open the interactive dashboard and test the filters.*

---

## 1. The Business Problem (Process Leak)
A SaaS client was experiencing **"Silent Churn"**—customers leaving without warning.
In engineering terms, the "mass balance" of the customer base was negative (Churn > Acquisition).
The goal was to build an **Early Warning System** to detect at-risk revenue *before* it leaves the pipe.

## 2. The Solution: "Safety Factor" Risk Scoring
Instead of a "Black Box" AI model, I engineered a transparent **Heuristic Risk Engine** based on known failure modes.
This acts like a process control loop: IF risk factors exceed safety limits, THEN trigger an alert.

### The Risk Formula (SQL Logic)
We assigned weighted penalty points to specific customer behaviors:
- **Contract Volatility:** Month-to-month contracts (+40 Risk Pts)
- **Payment Friction:** Electronic Check payments (+15 Risk Pts)
- **Service Gaps:** No Tech Support (+20 Risk Pts)
- **Infrastructure:** Fiber Optic service complaints (+25 Risk Pts)

**Logic:** `Risk Score = Contract_Risk + Payment_Risk + Service_Risk`

## 3. The Tech Stack
- **Database:** SQL (Complex CTEs, Case Logic, Data "Mass Balance").
- **Visualization:** Tableau (Interactive "Control Room" Dashboard).
- **Architecture:** `Raw Data` -> `Mass Balance Join` -> `Risk Engine (SQL)` -> `Dashboard`.

## 4. Key Results (ROI)
- **Identified Revenue at Risk:** $249,610 (Monthly Flow Rate).
- **Primary Failure Mode:** Customers on **Month-to-Month** contracts paying via **Electronic Check** have a 90%+ churn probability.
- **Action Plan:** The "Intervention List" provides a prioritized work order for the Customer Success team to target the top 100 "Critical" accounts immediately.

---
*Built by Charles Aniji – Chemical Engineer turned Data Consultant.*
