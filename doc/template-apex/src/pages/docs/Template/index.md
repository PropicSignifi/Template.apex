---
title: "Template"
description: "Template"
layout: "guide"
icon: "flash"
weight: 1
---

###### {$page.description}

<article id="1">

## Template

A template is a string with interpolatable expressions in it. In Template.apex, we use
visualforce expression syntax to evaluate the templates.

```javascript
Template t = new Template();
String output = t.evaluate('{! name }', new Map<String, Object>{ 'name' => 'wilson' });
```

</article>
