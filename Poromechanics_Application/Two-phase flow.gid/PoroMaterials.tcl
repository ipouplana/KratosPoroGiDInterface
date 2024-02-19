proc WritePoroMaterials { basename dir problemtypedir PropertyId } {

    upvar $PropertyId MyPropertyId

    ## Start PoroMaterials.json file
    set filename [file join $dir PoroMaterials.json]
    set FileVar [open $filename w]

    puts $FileVar "\{"

    puts $FileVar "    \"properties\": \[\{"

    # Total number of groups with properties
    set Groups [GiD_Info conditions Body_Part groups]
    set NumGroups [llength $Groups]
    incr NumGroups $MyPropertyId
    # Body_Part
    set Groups [GiD_Info conditions Body_Part groups]
    for {set i 0} {$i < [llength $Groups]} {incr i} {
        incr MyPropertyId
        puts $FileVar "        \"model_part_name\": \"PorousModelPart.[lindex [lindex $Groups $i] 1]\","
        puts $FileVar "        \"properties_id\": $MyPropertyId,"
        puts $FileVar "        \"Material\": \{"
        puts $FileVar "            \"constitutive_law\": \{"
        if {[lindex [lindex $Groups $i] 3] eq "LinearElasticSolid3DLaw"} {
            if { ([GiD_AccessValue get gendata Initial_Stresses] eq false) || (([GiD_AccessValue get gendata Initial_Stresses] eq true) && ([GiD_AccessValue get gendata Mode] eq "save")) } {
                puts $FileVar "                \"name\": \"[lindex [lindex $Groups $i] 3]\""
            } else {
                puts $FileVar "                \"name\": \"HistoryLinearElastic3DLaw\""
            }
        } elseif {[lindex [lindex $Groups $i] 3] eq "LinearElasticPlaneStrainSolid2DLaw"} {
            if { ([GiD_AccessValue get gendata Initial_Stresses] eq false) || (([GiD_AccessValue get gendata Initial_Stresses] eq true) && ([GiD_AccessValue get gendata Mode] eq "save")) } {
                puts $FileVar "                \"name\": \"[lindex [lindex $Groups $i] 3]\""
            } else {
                puts $FileVar "                \"name\": \"HistoryLinearElasticPlaneStrain2DLaw\""
            }
        } elseif {[lindex [lindex $Groups $i] 3] eq "LinearElasticPlaneStressSolid2DLaw"} {
            if { ([GiD_AccessValue get gendata Initial_Stresses] eq false) || (([GiD_AccessValue get gendata Initial_Stresses] eq true) && ([GiD_AccessValue get gendata Mode] eq "save")) } {
                puts $FileVar "                \"name\": \"[lindex [lindex $Groups $i] 3]\""
            } else {
                puts $FileVar "                \"name\": \"HistoryLinearElasticPlaneStress2DLaw\""
            }
        } elseif {[lindex [lindex $Groups $i] 3] eq "SimoJuDamage3DLaw"} {
            if {[GiD_AccessValue get gendata Non-local_Damage] eq true} {
                puts $FileVar "                \"name\": \"SimoJuNonlocalDamage3DLaw\""
            } else {
                puts $FileVar "                \"name\": \"SimoJuLocalDamage3DLaw\""
            }
        } elseif {[lindex [lindex $Groups $i] 3] eq "SimoJuDamagePlaneStrain2DLaw"} {
            if {[GiD_AccessValue get gendata Non-local_Damage] eq true} {
                puts $FileVar "                \"name\": \"SimoJuNonlocalDamagePlaneStrain2DLaw\""
            } else {
                puts $FileVar "                \"name\": \"SimoJuLocalDamagePlaneStrain2DLaw\""
            }
        } elseif {[lindex [lindex $Groups $i] 3] eq "SimoJuDamagePlaneStress2DLaw"} {
            if {[GiD_AccessValue get gendata Non-local_Damage] eq true} {
                puts $FileVar "                \"name\": \"SimoJuNonlocalDamagePlaneStress2DLaw\""
            } else {
                puts $FileVar "                \"name\": \"SimoJuLocalDamagePlaneStress2DLaw\""
            }
        } elseif {[lindex [lindex $Groups $i] 3] eq "ModifiedMisesDamage3DLaw"} {
            puts $FileVar "                \"name\": \"ModifiedMisesNonlocalDamage3DLaw\""
        } elseif {[lindex [lindex $Groups $i] 3] eq "ModifiedMisesDamagePlaneStrain2DLaw"} {
            puts $FileVar "                \"name\": \"ModifiedMisesNonlocalDamagePlaneStrain2DLaw\""
        } elseif {[lindex [lindex $Groups $i] 3] eq "ModifiedMisesDamagePlaneStress2DLaw"} {
            puts $FileVar "                \"name\": \"ModifiedMisesNonlocalDamagePlaneStress2DLaw\""
        }
        puts $FileVar "            \},"
        puts $FileVar "            \"Variables\": \{"
        puts $FileVar "                \"SATURATION_LAW_NAME\": \"[lindex [lindex $Groups $i] 4]\","
        puts $FileVar "                \"YOUNG_MODULUS\": [lindex [lindex $Groups $i] 5],"
        puts $FileVar "                \"POISSON_RATIO\": [lindex [lindex $Groups $i] 6],"
        puts $FileVar "                \"DENSITY_SOLID\": [lindex [lindex $Groups $i] 7],"
        puts $FileVar "                \"DENSITY_LIQUID\": [lindex [lindex $Groups $i] 8],"
        puts $FileVar "                \"DENSITY_GAS\": [lindex [lindex $Groups $i] 9],"
        puts $FileVar "                \"POROSITY\": [lindex [lindex $Groups $i] 10],"
        puts $FileVar "                \"BULK_MODULUS_SOLID\": [lindex [lindex $Groups $i] 11],"
        puts $FileVar "                \"BULK_MODULUS_LIQUID\": [lindex [lindex $Groups $i] 12],"
        puts $FileVar "                \"BULK_MODULUS_GAS\": [lindex [lindex $Groups $i] 13],"
        puts $FileVar "                \"PERMEABILITY_XX\": [lindex [lindex $Groups $i] 14],"
        puts $FileVar "                \"PERMEABILITY_YY\": [lindex [lindex $Groups $i] 15],"
        puts $FileVar "                \"PERMEABILITY_ZZ\": [lindex [lindex $Groups $i] 16],"
        puts $FileVar "                \"PERMEABILITY_XY\": [lindex [lindex $Groups $i] 17],"
        puts $FileVar "                \"PERMEABILITY_YZ\": [lindex [lindex $Groups $i] 18],"
        puts $FileVar "                \"PERMEABILITY_ZX\": [lindex [lindex $Groups $i] 19],"
        puts $FileVar "                \"DYNAMIC_VISCOSITY_LIQUID\": [lindex [lindex $Groups $i] 20],"
        puts $FileVar "                \"DYNAMIC_VISCOSITY_GAS\": [lindex [lindex $Groups $i] 21],"
        puts $FileVar "                \"BIOT_COEFFICIENT\": [lindex [lindex $Groups $i] 22],"
        puts $FileVar "                \"GAS_DIFFUSION_COEFF\": [lindex [lindex $Groups $i] 23],"
        puts $FileVar "                \"RESIDUAL_LIQUID_SATURATION\": [lindex [lindex $Groups $i] 24],"
        puts $FileVar "                \"RESIDUAL_GAS_SATURATION\": [lindex [lindex $Groups $i] 25],"
        puts $FileVar "                \"PORE_SIZE_FACTOR\": [lindex [lindex $Groups $i] 26],"
        puts $FileVar "                \"GAS_ENTRY_PRESSURE\": [lindex [lindex $Groups $i] 27],"
        puts $FileVar "                \"MINIMUM_RELATIVE_PERMEABILITY\": [lindex [lindex $Groups $i] 28],"
        puts $FileVar "                \"THICKNESS\": [lindex [lindex $Groups $i] 29],"
        puts $FileVar "                \"DAMAGE_THRESHOLD\": [lindex [lindex $Groups $i] 30],"
        puts $FileVar "                \"STRENGTH_RATIO\": [lindex [lindex $Groups $i] 31],"
        puts $FileVar "                \"FRACTURE_ENERGY\": [lindex [lindex $Groups $i] 32],"
        puts $FileVar "                \"RESIDUAL_STRENGTH\": [lindex [lindex $Groups $i] 33],"
        puts $FileVar "                \"SOFTENING_SLOPE\": [lindex [lindex $Groups $i] 34]"
        puts $FileVar "            \},"
        puts $FileVar "            \"Tables\": \{\}"
        puts $FileVar "        \}"
        if {$MyPropertyId < $NumGroups} {
            puts $FileVar "    \},\{"
        } else {
            puts $FileVar "    \}\]"
        }
    }

    puts $FileVar "\}"

    close $FileVar
}
