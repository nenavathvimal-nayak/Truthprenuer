# Bayesian Truth Consensus Algorithm (`ALGORITHMS/VALIDATION/`)

## 1. Problem Formulation
Given a hypothesis claim $C$ submitted by a founder, multiple independent validators submit evidence evaluations $E_1, E_2, \dots, E_n$ with confidence scores $c_i \in [0, 1]$ and individual validator reputation weights $w_i \in [1, 1000]$.

## 2. Mathematical Model
The aggregated truth probability $P(C \mid E)$ is formulated as a reputation-weighted Bayesian update:

$$P(C \mid E) = \frac{P(C) \prod_{i=1}^n \left( c_i \cdot \frac{w_i}{\sum w_k} \right)}{P(E)}$$

Where:
- Prior $P(C) = 0.5$ (neutral prior for unverified claims).
- Effective weight $\omega_i = \log(1 + w_i)$ dampens power-law concentration.
- Threshold $\tau_{\text{verified}} = 0.75$: Claims exceeding $75\%$ posterior probability are stamped as **VERIFIED TRUTH**.
- Threshold $\tau_{\text{disputed}} = 0.40$: Claims falling below $40\%$ posterior probability are stamped as **DISPUTED EVIDENCE**.

## 3. Anti-Collusion Constraints
- Minimum independent validator quorum: $N \ge 3$.
- Maximum influence cap for a single validator: $\le 25\%$ of total vote weight in a single claim round.
