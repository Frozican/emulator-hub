# Emulator Hub reviews — setup

The hub is a static GitHub Pages site. Supabase stores review submissions; all new reviews default to `pending`. Public visitors cannot read reviews. Only Supabase Auth users explicitly listed in `review_admins` can read, approve, reject, or delete them.

## 1. Create Supabase project
1. Create a project at https://supabase.com/.
2. In Project Settings → API, copy the Project URL and the publishable key (or legacy anon key).
3. Put them in `supabase-config.js`. This is browser-visible configuration; **never use a service_role/secret key**.
4. In Authentication → Providers, enable Email/password. Create your admin user. If email confirmation is enabled, confirm the account.

## 2. Create the database and policies
Open SQL Editor in Supabase and run the complete `supabase/reviews.sql` file from this repository.

Then find your admin user's UUID in Authentication → Users and run:
```sql
insert into public.review_admins (user_id)
values ('PASTE-YOUR-AUTH-USER-UUID-HERE');
```
Do not expose the admin UUID as a password; access is controlled by Supabase Auth plus this allowlist.

## 3. Deploy
Commit `supabase-config.js`, `reviews-admin.html`, `reviews.js`, and the updated `index.html` to the GitHub Pages branch. Pages will publish the static UI; Supabase remains the database and auth service.

Admin page: `https://frozican.github.io/emulator-hub/reviews-admin.html`

## Security notes
- Review inserts are allowed only with status `pending`; browser submissions cannot approve themselves.
- There is no public SELECT policy, so reviews remain private.
- Admin read/update/delete is limited by `review_admins`.
- Do not put the Supabase service_role key in any file served by GitHub Pages.
- Consider adding CAPTCHA / rate limiting before promoting the form widely to reduce spam.
