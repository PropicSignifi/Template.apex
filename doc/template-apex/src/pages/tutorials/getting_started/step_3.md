---
title: "Evaluate Templates"
description: "Evaluate Templates"
buttonTitle: "Done"
parentId: "getting_started"
layout: "tutorial"
time: 90
weight: 3
---

## {$page.title}

To evaluate a template written in visualforce expression syntax, what you need is only one line.

```javascript
String output = new Template().evaluate('Hi {! UPPER(acc.Name) }', new Map<String, Object>{ 'acc' => new Account(...) };
```
