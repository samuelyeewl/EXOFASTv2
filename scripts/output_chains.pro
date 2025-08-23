pro output_chains, toi=toi, fitdir=fitdir

path = filepath('',root_dir=getenv('EXOFAST_PATH'),subdir=['fits','toi'+toi])

if n_elements(fitdir) eq 0 then $
    fitdir = 'fitresult'
print, path + fitdir + path_sep()
ssfile = path + fitdir + path_sep() + 'toi'+toi+'.mcmc.idl'

restore, ssfile

nsteps = mcmcss.nsteps/mcmcss.nchains
chi2 = reform((*mcmcss.chi2),nsteps,mcmcss.nchains)
burnndx = getburnndx(chi2,goodchains=goodchains)
ngoodchains = n_elements(goodchains)

print, 'BURNNDX', burnndx
print, 'NCHAINS', mcmcss.nchains
print, 'NGOODCHAINS', ngoodchains

minchi2 = min(*mcmcss.chi2,bestndx)

end

for i=0, n_tags(mcmcss)-1 do begin
    for j=0, n_elements(mcmcss.(i))-1 do begin
        print, mcmcss.(i)[j].label
        for k=0, n_tags(mcmcss.(i)[j])-1 do begin
            ;; capture the detrender variables
            if (size(mcmcss.(i)[j].(k)))[1] eq 10 then begin ;; if it's a pointer
                if ptr_valid(mcmcss.(i)[j].(k)) then begin ;; if it's not empty
                    for l=0L, n_tags(*(mcmcss.(i)[j].(k)))-1 do begin ;; loop through each tag
                        if (size((*(mcmcss.(i)[j].(k))).(l)))[2] eq 8 then begin  ;; if it's an array of structures
                            for m=0L, n_elements((*(mcmcss.(i)[j].(k))).(l))-1 do begin
                                print, i, j, k, l, m, ' ', (*(mcmcss.(i)[j].(k))).(l)[m].label
                            endfor
                        endif
                    endfor
                endif
            endif else if n_tags(mcmcss.(i)[j].(k)) ne 0 then begin
                print, i, j, k, ' ',  mcmcss.(i)[j].(k).label
            endif
        endfor
    endfor
endfor

end
