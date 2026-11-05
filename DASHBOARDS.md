# Separate Kstore workspaces

- `/admin`: verified administrators only. Review submitted seller applications and pending rider applications, inspect recent orders and delivery problems, and review recorded cash awaiting settlement.
- `/seller`: the signed-in account's seller centre, with products, orders, finance, learning and settings subroutes. Accounts without a store use seller onboarding.
- `/rider`: verified rider application and the approved rider's assigned jobs. `/courier` and old `/#/courier` bookmarks canonicalize to `/rider`.

These routes share Firebase sign-in, but do not share authorization. An account may legitimately hold several roles. A URL or client-side flag never grants permission to approve applications or read other accounts' records. The admin callable requires an enabled verified administrator's signed token; approved targets need enabled verified accounts and matching applications. Approval changes only seller/rider status and projections and records a server-owned audit event. It cannot grant administrator claims.

Administrator claims are assigned only by a trusted operator after the owner's explicit authorization. A newly authorized user can use Refresh access on `/admin` or sign out/in to obtain a fresh token. Signing out clears the client-side operations data and role flag. Site audience access remains separate from Firebase roles; this release does not make the Site public.

Admin lists load at most 50 sellers, 50 riders and the 50 most recent orders. Counts explicitly describe loaded records. Cash review is read-only: it does not reconcile, transfer or settle funds. Automatic approval, document verification, SMTP/SMS and payouts are not implemented.

Clean routes use static entry documents with root-relative resolution, generated from the shared `dist/index.html` by `node prepare-dashboard-routes.mjs`. Run this after editing the entry document and before packaging. Existing hash navigation remains supported and dashboard links canonicalize to clean paths. The local server serves directory index documents so direct navigation and reload can be checked before publication.

Release validation: all 33 backend tests passed. Ten synthetic rendering/routing checks passed, including eleven local clean-URL entry requests. Authenticated browser QA remains incomplete: the initial run went offline and subsequent Chrome/connected-browser startup failed. These failures are not successful UI tests. Review the three signed-in workspaces in a working browser after release; the owner-approved Alex account has the administrator claim.
