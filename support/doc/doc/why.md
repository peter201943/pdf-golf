# why

- why this layout?
- need a way to include everything, organized

```yaml
golf:                           # the whole project
  game:                         # anything which will be in the game when it is exported
    class:                      # scripts, code
    scene:                      # prefabs, levels
    - demo_01.tscn
  support:                      # anything outside of the game when exported
    doc:                        # semantic knowledge
      dev:                      # workflow, how-tos, technicals
      - getting_started.md
      doc:                      # notes on the documentation itself
      - why.md
      gameplay:                 # notes on game-design, attacks, bonuses
      - golfers.md
      - griefers.md
      - movement.md
    model:                      # any high-res models which aren't ready to be imported yet
    texture:                    # " ... "
```

- you can think of the entirety of the `support/doc` folder as a forum
- feel free to edit the docs in here and push them up to master