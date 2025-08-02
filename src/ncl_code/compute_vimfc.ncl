ptop = 300              ; 'shum' upper level
ptop@units = "hPa"
g    = 9.80665        ; m/s2


diri = "/home/owner/Documents/Memorial_Project/"
fil = "merged_quv_output.nc"
filps = "merged_sp_output.nc"

pth = diri+fil
pthps= diri+filps

f   = addfile(pth ,"r")
fps  = addfile(pthps ,"r")

u    = f->u(:,{1000:300},{-15:15},{5:35})
v    = f->v(:,{1000:300},{-15:15},{5:35})
q    = f->q(:,{1000:300},{-15:15},{5:35})
sp   = fps->sp(:,{-15:15},{5:35})


ptop = (/ptop*100/)
ptop@units = "Pa"
plev  = (/q&pressure_level*100/)
plev@units = "Pa"

q  = (/q*1000/)
q@units = "g/kg"




dp   = dpres_plevel_Wrap(plev, sp, ptop, 0)
dpg  = dp/g
dpg@units     = "kg/m2"

uq   = u*q
uq@long_name = "Zonal Moisture Flux [uq]"
uq@units = "["+u@units+"]["+q@units+"]"
copy_VarMeta(u,uq)

vq   = v*q
vq@long_name = "Meridional Moisture Flux [vq]"
vq@units = "["+v@units+"]["+q@units+"]"
copy_VarMeta(v,vq)

uq_dpg = (/uq*dpg/)
iuq    = dim_sum_n(uq_dpg, 1)
iuq@long_name = "Integrated Zonal UQ [uq*dpg]"
iuq@LONG_NAME = "Sum: Mass Weighted Integrated Zonal Moisture Flux [uq*dpg]"
iuq@units     = "[m/s][g/kg]"
copy_VarMeta(u(:,0,:,:), iuq) ; (time,lat,lon)
delete(uq_dpg)

vq_dpg = (/vq*dpg/)
ivq    = dim_sum_n(vq_dpg, 1)
ivq@long_name = "Integrated Meridional VQ [vq*dpg]"
ivq@LONG_NAME = "Sum: Mass Weighted Integrated Meridional Moisture Flux [vq*dpg]"
ivq@units     = "[m/s][g/kg]"
copy_VarMeta(v(:,0,:,:), ivq) ; (time,lat,lon)
delete(vq_dpg)


;duvq  = uv2dvF_Wrap(uq, vq)
duvq  =uv2dv_cfd(uq, vq, u&latitude, u&longitude, 2)
duvq@long_name = "Divergence of Moisture Flux"
duvq@units     = "g/(kg-s)"

duvq_dpg = (/duvq*dpg/)
iduvq    = dim_sum_n(duvq_dpg, 1)
iduvq@long_name = "Integrated Mass Wgt MFC"
iduvq@LONG_NAME = "Integrated Mass Weighted Moisture Flux Convergence"
iduvq@units     = "g/(m2-s)"
copy_VarMeta(u(:,0,:,:), iduvq)
delete(duvq_dpg)

VIMFC =  iduvq           ; keep meta data
VIMFC = (/-1*VIMFC/)           ; Note the preceding -1 [negative precedes integration]
VIMFC@long_name = "VIMFC"

f = addfile("/home/owner/Documents/Memorial_Project/Vertical_Integrated_Moisture_convergence_global.nc","c")

f->VIMFC     = VIMFC ;(date|:,latitude|:,longitude|:)
f->qz        = iuq ;(date|:,latitude|:,longitude|:)
f->qm        = ivq ;(date|:,latitude|:,longitude|:)

