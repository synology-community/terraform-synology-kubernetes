locals {
  nodes = { for i, node in var.nodes : (coalesce(node.name, "${var.name}-${i}")) => merge(node, { primary = (i == 0 && var.type == "system"), control_plane = (var.type == "system") }) }
}
