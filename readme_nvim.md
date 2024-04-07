# Additional requirements
* fd-find (`sudo apt install fd-find`)
* ripgrep (`sudo apt install ripgrep`)

# Key-Bindings
## NeoTree
* LEADER e - Toggles the file explorer

## Telescope
* LEADER sg - Search in files


## Buffer
* Shift-PageUp - prev Buffer
* Shift-PageDown - next Buffer
* Shift h, j, k, l - you know

## Windows
* CTRL-LEFT - left window 
* CTRL-RIGHT - right window 
* CTRL h, j, k, l - ...
* LEADER + - increase width
* LEADER - - decrease width 
* CTRL-UP - increase height
* CTRL-DOWN - dcrease height 

## Debugging
### General
* LEADER du - toggle dap-ui 
* LEADER db - toggle breakpoint
* LEADER dt - terminate dap session
* LEADER dc - continue
* LEADER dO - step over (changed from default)
* LEADER do - step out (changed from default)

### Python
* LEADER dpt - test current test function
* LEADER dpc - test current test class

# Colorschemes
Previously used

## Sonokai
```lua
return {
  { "sainnhe/sonokai" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "sonokai",
    },
  },
}

```
