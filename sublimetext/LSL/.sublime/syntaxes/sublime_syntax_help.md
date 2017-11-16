# Sublime Syntax help

<https://github.com/kkos/oniguruma/blob/master/doc/RE>

## meta patterns

```yaml
main:
  - match: ''
    push:
      - clear_scopes: true
      - meta_scope: 'including triggers'
      - meta_content_scope: 'excluding triggers'
      - meta_include_prototype: ''
    with_prototype:
      - match: ''
        pop: true
  - match: ''
    scope: ''
```

## match

### push, pop, set, syntax are exclusive… only use one within a single match pattern!

```yaml
- match: ''
  scope: ''
  captures:
    1: ''
    2: ''
  push: ''
  pop: true
  set: ''
  syntax: ''
```

## include

### meta patterns defined in include are ignored

####prototype will be included at the top of every context, except where meta_include_prototype is false

```yaml
prototype:
  - include: ''

string:
  - meta_include_prototype: false
```

## variables

```yaml
variables:
  one: '…'
contexts:
  main:
    - match: '\b{{one}}\b'
      scope: ''
```
