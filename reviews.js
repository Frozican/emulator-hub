(() => {
 const form=document.querySelector("#review-form");
 if(!form)return;
 const status=document.querySelector("#review-status");
 const cfg=window.EMULATOR_HUB_SUPABASE||{};
 const ready=cfg.url&&cfg.anonKey&&!cfg.url.includes("YOUR-PROJECT")&&!cfg.anonKey.includes("YOUR_SUPABASE")&&window.supabase;
 if(!ready){status.textContent="The review form is not configured yet. Please try again later.";form.querySelector("button").disabled=true;return}
 const db=window.supabase.createClient(cfg.url,cfg.anonKey);
 const stars=[...form.querySelectorAll('input[name="rating"]')];
 form.addEventListener("submit",async e=>{
  e.preventDefault();const button=form.querySelector('button[type="submit"]');button.disabled=true;status.textContent="Submitting…";
  const values=new FormData(form);
  const entry={display_name:(String(values.get("display_name")||"Anonymous").trim()||"Anonymous"),rating:Number(values.get("rating")),title:String(values.get("title")||"").trim(),body:String(values.get("body")||"").trim(),status:"pending"};
  const {error}=await db.from("reviews").insert(entry);
  if(error){status.textContent="Could not submit your review. Please try again later.";button.disabled=false;return}
  form.reset();status.textContent="Thank you! Your review was received and will stay private until the site owner reviews it.";button.disabled=false;
 });
})();