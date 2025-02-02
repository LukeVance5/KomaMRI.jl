
function plotInteract()
    @manipulate for t0_ms = range(0,dur(seq);length=5)*1e3
        plot_phantom_map(phantom, :ρ; t0=t0_ms, darkmode)
    end
end
plt = Observable{Any}(plotInteract())

function makebuttons(ph)
    prop = propertynames(ph)[5:end-3] #Removes name,x,y,z and ux,uy,uz
    propnm = [s for s=string.(prop)]
    buttons = button.(propnm)
    for (btn, key) in zip(reverse(buttons), reverse(prop))
        map!(t -> begin
            @manipulate for t0_ms = range(0,dur(seq);length=5)*1e3
                plot_phantom_map(ph, key; t0=t0_ms, darkmode)
            end
        end
        , plt, btn)
    end
    dom"div"(hbox(buttons))
end
columnbuttons = Observable{Any}(makebuttons(phantom))

map!(makebuttons, columnbuttons, pha_obs)
ui = dom"div"(vbox(columnbuttons, plt))
content!(w, "div#content", ui)
@js_ w document.getElementById("content").dataset.content = "phantom"
