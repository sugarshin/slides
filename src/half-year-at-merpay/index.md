---
title: Merpay での半年間 - @sugarshin's slide | slides.sugarshin.net
description: Merpay での半年間 - @sugarshin's slide | slides.sugarshin.net
url: https://slides.sugarshin.net/half-year-at-merpay
image: https://slides.sugarshin.net/half-year-at-merpay/index.png
---

# Merpay での半年間

---

## Self Introduction

---

<img src="images/g.png" style="display: block; margin: 0 auto;">

---

<img src="images/h.png" style="display: block; margin: 0 auto;">

---

<img src="images/b.png" style="display: block; margin: 0 auto;">

---

<img src="images/i0.png" style="display: block; margin: 0 auto;">

---

<img src="images/i1.png" style="display: block; margin: 0 auto;">

---

<img src="images/i2.png" style="display: block; margin: 0 auto;">

---

<!-- <img src="images/i3.png" style="display: block; margin: 0 auto;">

---

<p style="text-align: center; font-size: 2em;"><a href="https://ins0.jp/" target="_blank">ins0.jp</a></p>

--- -->

## Merpay Frontend Team

---

<img src="images/m.png" style="display: block; margin: 0 auto;">

---

- CS Tool
- Merpay Partners Admin Tool
- Merchants Registration Form
- Campaign LP
- Coupon WebView

---

<p style="text-align: center; font-size: 2em;">
  Campaign LP /
  Coupon WebView
</p>

---

<img src="images/c.png" style="display: block; margin: 0 auto;">

---

<img src="images/n.png" style="display: block; margin: 0 auto; width: 30%; height: auto;">

---

<p style="text-align: center; font-size: 2em;">Designers can operation by itself</p>

---

- Componentization
- Encapsulation
- Templating
- Simplicity

---

<img src="images/d.png" style="display: block; margin: 0 auto;">

---

```ts
export function denyProduction({ env, error }: Context) {
  if (env.APP_ENV === 'production') {
    return error({ statusCode: 404 });
  }
}
```

---

```ts
export function staticAssetsAccessControl(this: any, moduleOptions: ModuleOptions) {
  this.nuxt.hook('render:setupMiddleware', (app: Server) => {
    app.use((req: http.IncomingMessage, res: http.ServerResponse, next: (err?: any) => void) => {
      const { pathname } = parseUrl(req.url);

      if (/* check the `pathname` */) {
        return options.denyCallback(res);
      }

      return next();
    });
  });
```

---

<p style="text-align: center; font-size: 4em;">🙏</p>
