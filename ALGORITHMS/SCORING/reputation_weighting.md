# Validator Reputation Scoring Algorithm (`ALGORITHMS/SCORING/`)

## 1. Reputation Calibration Formula
Validator reputation score $R_u$ dynamically updates based on empirical track record and alignment with ultimate peer consensus:

$$R_u = R_{\text{base}} + \sum_{k=1}^m \Delta R_k$$

Where:
$$\Delta R_k = 
\begin{cases} 
+10 \cdot \gamma_k & \text{if validation aligns with consensus} \\
-15 \cdot (1 - \gamma_k) & \text{if validation contradicts audited consensus} \\
0 & \text{if validation abstained}
\end{cases}$$

Here $\gamma_k$ represents the claim confidence coefficient.

## 2. Inactivity Decay & Slashing
- Inactive accounts decay by $1\%$ per 30 days without activity.
- Malicious coordination or bot submissions trigger immediate administrative slashing to $0$ and account suspension.
- Implementation lives in [`DATABASE/FUNCTIONS/stored_procedures.sql`](file:///Volumes/NAYAK/taeed_flutter_source/DATABASE/FUNCTIONS/stored_procedures.sql) (`recalculate_user_reputation`).
