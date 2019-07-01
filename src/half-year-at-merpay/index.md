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

<img src="/half-year-at-merpay/images/g.png" style="display: block; margin: 0 auto;">

---

<img src="/half-year-at-merpay/images/h.png" style="display: block; margin: 0 auto;">

---

<img src="/half-year-at-merpay/images/b.png" style="display: block; margin: 0 auto;">

---

<img src="/half-year-at-merpay/images/i0.png" style="display: block; margin: 0 auto;">

---

<img src="/half-year-at-merpay/images/i1.png" style="display: block; margin: 0 auto;">

---

<img src="/half-year-at-merpay/images/i2.png" style="display: block; margin: 0 auto;">

---

<!-- <img src="/half-year-at-merpay/images/i3.png" style="display: block; margin: 0 auto;">

---

<p style="text-align: center; font-size: 2em;"><a href="https://ins0.jp/" target="_blank">ins0.jp</a></p>

--- -->

## Merpay Frontend Team

---

<img src="/half-year-at-merpay/images/m.png" style="display: block; margin: 0 auto;">

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

<img src="/half-year-at-merpay/images/c.png" style="display: block; margin: 0 auto;">

---

<img src="/half-year-at-merpay/images/n.png" style="display: block; margin: 0 auto; width: 30%; height: auto;">

---

<p style="text-align: center; font-size: 2em;">Designers can operation by itself</p>

---

- Componentization
- Encapsulation
- Templating
- Simplicity

---

<img src="/half-year-at-merpay/images/d.png" style="display: block; margin: 0 auto;">

---

```ts
import { Context } from '@nuxt/vue-app';

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
