workflow "New workflow" {
  on = "push"
  resolves = ["First interactionjhk"]
}

action "First interactionjhk" {
  uses = "actions/first-interaction@2144f78be88bf9535ecaf0cde2469967580893a9"
}
