workflow "New workflow" {
  on = "push"
  resolves = ["First interaction"]
}

action "First interaction" {
  uses = "actions/first-interaction@2144f78be88bf9535ecaf0cde2469967580893a9"
}
