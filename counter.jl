using WebAssemblyCompiler
const W = WebAssemblyCompiler
W.setdebug(:offline)

# This utility updates the page inputs.
mdpadnum(x) = @jscall("x => mdpad[x]", Float64, Tuple{Externref}, JS.object(x))
update_params() = mdpadnum("index")

# This function updates the counter display.
function update_innnerHTML(id, src)
    @jscall(
        "(id, src) => document.getElementById(id).innerHTML = src",
        Nothing,
        Tuple{Externref, Externref},
        JS.object(id),
        src
    )
end

function update_output(index)
    update_innnerHTML("counter", """<p>Count = $index</p>""")
    nothing
end

"""
    update()

My WASM interface
"""
function update()
    index::Int = update_params()
    update_output(index)
    nothing
end

# Compile `update` to WebAssembly:
compile((update,), filepath = "counter/counter.wasm", validate = true)
