
function days_vac_f()

    v = [i for i in 107:(107+219)]
    
    return v
end

function vaccination_rate_1()
    if p.prov == :arkansas
        v = [0 0 0 0 0 0 0 0;

        ]
    elseif p.prov == :mississippi
        v = [0 0 0 0 0 0 0 0;
            
        ]
    end


    if p.scenario == :statuscuo

    elseif p.scenario == :half
        v = Int.(round.(v/2))
    else
        v = [0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0]
    end

    return v
end

function vaccination_rate_2()
    
    if p.prov == :arkansas
        v = [0 0 0 0 0 0 0 0;
    
        ]
    elseif p.prov == :mississippi
        v = [0 0 0 0 0 0 0 0;
            
        ]
    end

    if p.scenario == :statuscuo

    elseif p.scenario == :half
        v = Int.(round.(v/2.0))
    else
        v = [0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0]
    end
    return v
end