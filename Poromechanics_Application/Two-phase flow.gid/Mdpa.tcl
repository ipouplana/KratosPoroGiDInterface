proc WriteMdpa { basename dir problemtypedir } {

    ## Source auxiliar procedures
    source [file join $problemtypedir MdpaAuxProcs.tcl]

    ## Start MDPA file
    set filename [file join $dir ${basename}.mdpa]
    set FileVar [open $filename w]

    ## ModelPart Data
    #puts $FileVar "Begin ModelPartData"
    #puts $FileVar "  // VARIABLE_NAME value"
    #puts $FileVar "End ModelPartData"
    #puts $FileVar ""
    #puts $FileVar ""

    ## Tables
    set TableId 0
    set TableDict [dict create]
    # Solid_Displacement
    ConstraintVectorTable FileVar TableId TableDict Solid_Displacement DISPLACEMENT
    # Liquid_Pressure
    PressureTable FileVar TableId TableDict Liquid_Pressure LIQUID_PRESSURE
    # Gas_Pressure
    PressureTable FileVar TableId TableDict Gas_Pressure GAS_PRESSURE
    # Force
    VectorTable FileVar TableId TableDict Force FORCE
    # Face_Load
    VectorTable FileVar TableId TableDict Face_Load FACE_LOAD
    # Face_Load_Control_Module
    VectorTable FileVar TableId TableDict Face_Load_Control_Module FACE_LOAD
    # Normal_Load
    NormalTangentialTable FileVar TableId TableDict Normal_Load NORMAL_CONTACT_STRESS TANGENTIAL_CONTACT_STRESS
    # Normal_Liquid_Flux
    ScalarTable FileVar TableId TableDict Normal_Liquid_Flux NORMAL_LIQUID_FLUX
    # Normal_Gas_Flux
    ScalarTable FileVar TableId TableDict Normal_Gas_Flux NORMAL_GAS_FLUX
    # Body_Acceleration
    VectorTable FileVar TableId TableDict Body_Acceleration VOLUME_ACCELERATION
    puts $FileVar ""

    ## Properties
    puts $FileVar "Begin Properties 0"
    puts $FileVar "End Properties"

    set PropertyId 0
    set PropertyDict [dict create]
    # Body_Part
    set Groups [GiD_Info conditions Body_Part groups]
    for {set i 0} {$i < [llength $Groups]} {incr i} {
        if {[lindex [lindex $Groups $i] 3] eq "LinearElasticSolid3DLaw"} {
            incr PropertyId
            dict set PropertyDict [lindex [lindex $Groups $i] 1] $PropertyId
            puts $FileVar "Begin Properties $PropertyId"
            if { ([GiD_AccessValue get gendata Initial_Stresses] eq false) || (([GiD_AccessValue get gendata Initial_Stresses] eq true) && ([GiD_AccessValue get gendata Mode] eq "save")) } {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME LinearElasticSolid3DLaw"
            } else {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME HistoryLinearElastic3DLaw"
            }
            puts $FileVar "  YOUNG_MODULUS [lindex [lindex $Groups $i] 4]"
            puts $FileVar "  POISSON_RATIO [lindex [lindex $Groups $i] 5]"
            puts $FileVar "  DENSITY_SOLID [lindex [lindex $Groups $i] 6]"
            puts $FileVar "  DENSITY_LIQUID [lindex [lindex $Groups $i] 7]"
            puts $FileVar "  POROSITY [lindex [lindex $Groups $i] 8]"
            puts $FileVar "  BULK_MODULUS_SOLID [lindex [lindex $Groups $i] 9]"
            puts $FileVar "  BULK_MODULUS_LIQUID [lindex [lindex $Groups $i] 10]"
            puts $FileVar "  PERMEABILITY_XX [lindex [lindex $Groups $i] 11]"
            puts $FileVar "  PERMEABILITY_YY [lindex [lindex $Groups $i] 12]"
            puts $FileVar "  PERMEABILITY_ZZ [lindex [lindex $Groups $i] 13]"
            puts $FileVar "  PERMEABILITY_XY [lindex [lindex $Groups $i] 14]"
            puts $FileVar "  PERMEABILITY_YZ [lindex [lindex $Groups $i] 15]"
            puts $FileVar "  PERMEABILITY_ZX [lindex [lindex $Groups $i] 16]"
            puts $FileVar "  DYNAMIC_VISCOSITY [lindex [lindex $Groups $i] 17]"
            puts $FileVar "  THICKNESS [lindex [lindex $Groups $i] 18]"
            puts $FileVar "  BIOT_COEFFICIENT [lindex [lindex $Groups $i] 24]"
            puts $FileVar "End Properties"
            puts $FileVar ""
        } elseif { ([lindex [lindex $Groups $i] 3] eq "LinearElasticPlaneStrainSolid2DLaw") || ([lindex [lindex $Groups $i] 3] eq "LinearElasticPlaneStressSolid2DLaw")} {
            incr PropertyId
            dict set PropertyDict [lindex [lindex $Groups $i] 1] $PropertyId
            puts $FileVar "Begin Properties $PropertyId"
            if { ([GiD_AccessValue get gendata Initial_Stresses] eq false) || (([GiD_AccessValue get gendata Initial_Stresses] eq true) && ([GiD_AccessValue get gendata Mode] eq "save")) } {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME [lindex [lindex $Groups $i] 3]"
            } else {
                if {[lindex [lindex $Groups $i] 3] eq "LinearElasticPlaneStrainSolid2DLaw"} {
                    puts $FileVar "  CONSTITUTIVE_LAW_NAME HistoryLinearElasticPlaneStrain2DLaw"
                } else {
                    puts $FileVar "  CONSTITUTIVE_LAW_NAME HistoryLinearElasticPlaneStress2DLaw"
                }
            }
            puts $FileVar "  YOUNG_MODULUS [lindex [lindex $Groups $i] 4]"
            puts $FileVar "  POISSON_RATIO [lindex [lindex $Groups $i] 5]"
            puts $FileVar "  DENSITY_SOLID [lindex [lindex $Groups $i] 6]"
            puts $FileVar "  DENSITY_LIQUID [lindex [lindex $Groups $i] 7]"
            puts $FileVar "  POROSITY [lindex [lindex $Groups $i] 8]"
            puts $FileVar "  BULK_MODULUS_SOLID [lindex [lindex $Groups $i] 9]"
            puts $FileVar "  BULK_MODULUS_LIQUID [lindex [lindex $Groups $i] 10]"
            puts $FileVar "  PERMEABILITY_XX [lindex [lindex $Groups $i] 11]"
            puts $FileVar "  PERMEABILITY_YY [lindex [lindex $Groups $i] 12]"
            puts $FileVar "  PERMEABILITY_XY [lindex [lindex $Groups $i] 14]"
            puts $FileVar "  DYNAMIC_VISCOSITY [lindex [lindex $Groups $i] 17]"
            puts $FileVar "  THICKNESS [lindex [lindex $Groups $i] 18]"
            puts $FileVar "  BIOT_COEFFICIENT [lindex [lindex $Groups $i] 24]"
            puts $FileVar "End Properties"
            puts $FileVar ""
        } elseif {[lindex [lindex $Groups $i] 3] eq "SimoJuDamage3DLaw"} {
            incr PropertyId
            dict set PropertyDict [lindex [lindex $Groups $i] 1] $PropertyId
            puts $FileVar "Begin Properties $PropertyId"
            if {[GiD_AccessValue get gendata Non-local_Damage] eq true} {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME SimoJuNonlocalDamage3DLaw"
            } else {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME SimoJuLocalDamage3DLaw"
            }
            puts $FileVar "  YOUNG_MODULUS [lindex [lindex $Groups $i] 4]"
            puts $FileVar "  POISSON_RATIO [lindex [lindex $Groups $i] 5]"
            puts $FileVar "  DENSITY_SOLID [lindex [lindex $Groups $i] 6]"
            puts $FileVar "  DENSITY_LIQUID [lindex [lindex $Groups $i] 7]"
            puts $FileVar "  POROSITY [lindex [lindex $Groups $i] 8]"
            puts $FileVar "  BULK_MODULUS_SOLID [lindex [lindex $Groups $i] 9]"
            puts $FileVar "  BULK_MODULUS_LIQUID [lindex [lindex $Groups $i] 10]"
            puts $FileVar "  PERMEABILITY_XX [lindex [lindex $Groups $i] 11]"
            puts $FileVar "  PERMEABILITY_YY [lindex [lindex $Groups $i] 12]"
            puts $FileVar "  PERMEABILITY_ZZ [lindex [lindex $Groups $i] 13]"
            puts $FileVar "  PERMEABILITY_XY [lindex [lindex $Groups $i] 14]"
            puts $FileVar "  PERMEABILITY_YZ [lindex [lindex $Groups $i] 15]"
            puts $FileVar "  PERMEABILITY_ZX [lindex [lindex $Groups $i] 16]"
            puts $FileVar "  DYNAMIC_VISCOSITY [lindex [lindex $Groups $i] 17]"
            puts $FileVar "  THICKNESS [lindex [lindex $Groups $i] 18]"
            puts $FileVar "  DAMAGE_THRESHOLD [lindex [lindex $Groups $i] 19]"
            puts $FileVar "  STRENGTH_RATIO [lindex [lindex $Groups $i] 20]"
            puts $FileVar "  FRACTURE_ENERGY [lindex [lindex $Groups $i] 21]"
            puts $FileVar "  BIOT_COEFFICIENT [lindex [lindex $Groups $i] 24]"
            puts $FileVar "End Properties"
            puts $FileVar ""
        } elseif {([lindex [lindex $Groups $i] 3] eq "SimoJuDamagePlaneStrain2DLaw") || ([lindex [lindex $Groups $i] 3] eq "SimoJuDamagePlaneStress2DLaw")} {
            incr PropertyId
            dict set PropertyDict [lindex [lindex $Groups $i] 1] $PropertyId
            puts $FileVar "Begin Properties $PropertyId"
            if {[GiD_AccessValue get gendata Non-local_Damage] eq true} {
                if {[lindex [lindex $Groups $i] 3] eq "SimoJuDamagePlaneStrain2DLaw"} {
                    puts $FileVar "  CONSTITUTIVE_LAW_NAME SimoJuNonlocalDamagePlaneStrain2DLaw"
                } else {
                    puts $FileVar "  CONSTITUTIVE_LAW_NAME SimoJuNonlocalDamagePlaneStress2DLaw"
                }
            } else {
                if {[lindex [lindex $Groups $i] 3] eq "SimoJuDamagePlaneStrain2DLaw"} {
                    puts $FileVar "  CONSTITUTIVE_LAW_NAME SimoJuLocalDamagePlaneStrain2DLaw"
                } else {
                    puts $FileVar "  CONSTITUTIVE_LAW_NAME SimoJuLocalDamagePlaneStress2DLaw"
                }
            }
            puts $FileVar "  YOUNG_MODULUS [lindex [lindex $Groups $i] 4]"
            puts $FileVar "  POISSON_RATIO [lindex [lindex $Groups $i] 5]"
            puts $FileVar "  DENSITY_SOLID [lindex [lindex $Groups $i] 6]"
            puts $FileVar "  DENSITY_LIQUID [lindex [lindex $Groups $i] 7]"
            puts $FileVar "  POROSITY [lindex [lindex $Groups $i] 8]"
            puts $FileVar "  BULK_MODULUS_SOLID [lindex [lindex $Groups $i] 9]"
            puts $FileVar "  BULK_MODULUS_LIQUID [lindex [lindex $Groups $i] 10]"
            puts $FileVar "  PERMEABILITY_XX [lindex [lindex $Groups $i] 11]"
            puts $FileVar "  PERMEABILITY_YY [lindex [lindex $Groups $i] 12]"
            puts $FileVar "  PERMEABILITY_XY [lindex [lindex $Groups $i] 14]"
            puts $FileVar "  DYNAMIC_VISCOSITY [lindex [lindex $Groups $i] 17]"
            puts $FileVar "  THICKNESS [lindex [lindex $Groups $i] 18]"
            puts $FileVar "  DAMAGE_THRESHOLD [lindex [lindex $Groups $i] 19]"
            puts $FileVar "  STRENGTH_RATIO [lindex [lindex $Groups $i] 20]"
            puts $FileVar "  FRACTURE_ENERGY [lindex [lindex $Groups $i] 21]"
            puts $FileVar "  BIOT_COEFFICIENT [lindex [lindex $Groups $i] 24]"
            puts $FileVar "End Properties"
            puts $FileVar ""
        } elseif {[lindex [lindex $Groups $i] 3] eq "ModifiedMisesDamage3DLaw"} {
            incr PropertyId
            dict set PropertyDict [lindex [lindex $Groups $i] 1] $PropertyId
            puts $FileVar "Begin Properties $PropertyId"
            puts $FileVar "  CONSTITUTIVE_LAW_NAME ModifiedMisesNonlocalDamage3DLaw"
            puts $FileVar "  YOUNG_MODULUS [lindex [lindex $Groups $i] 4]"
            puts $FileVar "  POISSON_RATIO [lindex [lindex $Groups $i] 5]"
            puts $FileVar "  DENSITY_SOLID [lindex [lindex $Groups $i] 6]"
            puts $FileVar "  DENSITY_LIQUID [lindex [lindex $Groups $i] 7]"
            puts $FileVar "  POROSITY [lindex [lindex $Groups $i] 8]"
            puts $FileVar "  BULK_MODULUS_SOLID [lindex [lindex $Groups $i] 9]"
            puts $FileVar "  BULK_MODULUS_LIQUID [lindex [lindex $Groups $i] 10]"
            puts $FileVar "  PERMEABILITY_XX [lindex [lindex $Groups $i] 11]"
            puts $FileVar "  PERMEABILITY_YY [lindex [lindex $Groups $i] 12]"
            puts $FileVar "  PERMEABILITY_ZZ [lindex [lindex $Groups $i] 13]"
            puts $FileVar "  PERMEABILITY_XY [lindex [lindex $Groups $i] 14]"
            puts $FileVar "  PERMEABILITY_YZ [lindex [lindex $Groups $i] 15]"
            puts $FileVar "  PERMEABILITY_ZX [lindex [lindex $Groups $i] 16]"
            puts $FileVar "  DYNAMIC_VISCOSITY [lindex [lindex $Groups $i] 17]"
            puts $FileVar "  THICKNESS [lindex [lindex $Groups $i] 18]"
            puts $FileVar "  DAMAGE_THRESHOLD [lindex [lindex $Groups $i] 19]"
            puts $FileVar "  STRENGTH_RATIO [lindex [lindex $Groups $i] 20]"
            puts $FileVar "  RESIDUAL_STRENGTH [lindex [lindex $Groups $i] 22]"
            puts $FileVar "  SOFTENING_SLOPE [lindex [lindex $Groups $i] 23]"
            puts $FileVar "  BIOT_COEFFICIENT [lindex [lindex $Groups $i] 24]"
            puts $FileVar "End Properties"
            puts $FileVar ""
        } elseif {[lindex [lindex $Groups $i] 3] eq "ModifiedMisesDamagePlaneStrain2DLaw" || [lindex [lindex $Groups $i] 3] eq "ModifiedMisesDamagePlaneStress2DLaw"} {
            incr PropertyId
            dict set PropertyDict [lindex [lindex $Groups $i] 1] $PropertyId
            puts $FileVar "Begin Properties $PropertyId"
            if {[lindex [lindex $Groups $i] 3] eq "ModifiedMisesDamagePlaneStrain2DLaw"} {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME ModifiedMisesNonlocalDamagePlaneStrain2DLaw"
            } else {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME ModifiedMisesNonlocalDamagePlaneStress2DLaw"
            }
            puts $FileVar "  YOUNG_MODULUS [lindex [lindex $Groups $i] 4]"
            puts $FileVar "  POISSON_RATIO [lindex [lindex $Groups $i] 5]"
            puts $FileVar "  DENSITY_SOLID [lindex [lindex $Groups $i] 6]"
            puts $FileVar "  DENSITY_LIQUID [lindex [lindex $Groups $i] 7]"
            puts $FileVar "  POROSITY [lindex [lindex $Groups $i] 8]"
            puts $FileVar "  BULK_MODULUS_SOLID [lindex [lindex $Groups $i] 9]"
            puts $FileVar "  BULK_MODULUS_LIQUID [lindex [lindex $Groups $i] 10]"
            puts $FileVar "  PERMEABILITY_XX [lindex [lindex $Groups $i] 11]"
            puts $FileVar "  PERMEABILITY_YY [lindex [lindex $Groups $i] 12]"
            puts $FileVar "  PERMEABILITY_XY [lindex [lindex $Groups $i] 14]"
            puts $FileVar "  DYNAMIC_VISCOSITY [lindex [lindex $Groups $i] 17]"
            puts $FileVar "  THICKNESS [lindex [lindex $Groups $i] 18]"
            puts $FileVar "  DAMAGE_THRESHOLD [lindex [lindex $Groups $i] 19]"
            puts $FileVar "  STRENGTH_RATIO [lindex [lindex $Groups $i] 20]"
            puts $FileVar "  RESIDUAL_STRENGTH [lindex [lindex $Groups $i] 22]"
            puts $FileVar "  SOFTENING_SLOPE [lindex [lindex $Groups $i] 23]"
            puts $FileVar "  BIOT_COEFFICIENT [lindex [lindex $Groups $i] 24]"
            puts $FileVar "End Properties"
            puts $FileVar ""
        }
    }
    puts $FileVar ""

    ## Nodes
    set Nodes [GiD_Info Mesh Nodes]
    puts $FileVar "Begin Nodes"
    for {set i 0} {$i < [llength $Nodes]} {incr i 4} {
        # puts $FileVar "  [lindex $Nodes $i]  [lindex $Nodes [expr { $i+1 }]] [lindex $Nodes [expr { $i+2 }]] [lindex $Nodes [expr { $i+3 }]]"
        puts -nonewline $FileVar "  [lindex $Nodes $i]  "
        puts -nonewline $FileVar [format  "%.10f" [lindex $Nodes [expr { $i+1 }]]]
        puts -nonewline $FileVar " "
        puts -nonewline $FileVar [format  "%.10f" [lindex $Nodes [expr { $i+2 }]]]
        puts -nonewline $FileVar " "
        puts $FileVar [format  "%.10f" [lindex $Nodes [expr { $i+3 }]]]
    }
    puts $FileVar "End Nodes"
    puts $FileVar ""
    puts $FileVar ""

    ## Elements
    set FIC [GiD_AccessValue get gendata FIC_Stabilization]
    set IsQuadratic [GiD_Info Project Quadratic]
    # Body_Part
    set Groups [GiD_Info conditions Body_Part groups]
    if {$IsQuadratic eq 0} {
        if {$FIC eq false} {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                # Elements Property
                set BodyElemsProp [dict get $PropertyDict [lindex [lindex $Groups $i] 1]]

                # UPwSmallStrainElement2D3N
                WriteElements FileVar [lindex $Groups $i] triangle UPwSmallStrainElement2D3N 0 Triangle2D3Connectivities
                # UPwSmallStrainElement2D4N
                WriteElements FileVar [lindex $Groups $i] quadrilateral UPwSmallStrainElement2D4N 0 Quadrilateral2D4Connectivities
                # UPwSmallStrainElement3D4N
                WriteElements FileVar [lindex $Groups $i] tetrahedra UPwSmallStrainElement3D4N 0 Quadrilateral2D4Connectivities
                # UPwSmallStrainElement3D8N
                WriteElements FileVar [lindex $Groups $i] hexahedra UPwSmallStrainElement3D8N 0 Hexahedron3D8Connectivities
            }
        } else {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                # Elements Property
                set BodyElemsProp [dict get $PropertyDict [lindex [lindex $Groups $i] 1]]

                # UPwSmallStrainFICElement2D3N
                WriteElements FileVar [lindex $Groups $i] triangle UPwSmallStrainFICElement2D3N 0 Triangle2D3Connectivities
                # UPwSmallStrainFICElement2D4N
                WriteElements FileVar [lindex $Groups $i] quadrilateral UPwSmallStrainFICElement2D4N 0 Quadrilateral2D4Connectivities
                # UPwSmallStrainFICElement3D4N
                WriteElements FileVar [lindex $Groups $i] tetrahedra UPwSmallStrainFICElement3D4N 0 Quadrilateral2D4Connectivities
                # UPwSmallStrainFICElement3D8N
                WriteElements FileVar [lindex $Groups $i] hexahedra UPwSmallStrainFICElement3D8N 0 Hexahedron3D8Connectivities
            }
        }
    } elseif {$IsQuadratic eq 1} {
        for {set i 0} {$i < [llength $Groups]} {incr i} {
            # Elements Property
            set BodyElemsProp [dict get $PropertyDict [lindex [lindex $Groups $i] 1]]

            # SmallStrainUPwDiffOrderElement2D6N
            WriteElements FileVar [lindex $Groups $i] triangle SmallStrainUPwDiffOrderElement2D6N 0 Triangle2D6Connectivities
            # SmallStrainUPwDiffOrderElement2D8N
            WriteElements FileVar [lindex $Groups $i] quadrilateral SmallStrainUPwDiffOrderElement2D8N 0 Hexahedron3D8Connectivities
            # SmallStrainUPwDiffOrderElement3D10N
            WriteElements FileVar [lindex $Groups $i] tetrahedra SmallStrainUPwDiffOrderElement3D10N 0 Tetrahedron3D10Connectivities
            # SmallStrainUPwDiffOrderElement3D20N
            WriteElements FileVar [lindex $Groups $i] hexahedra SmallStrainUPwDiffOrderElement3D20N 0 Hexahedron3D20Connectivities
        }
    } else {
        for {set i 0} {$i < [llength $Groups]} {incr i} {
            # Elements Property
            set BodyElemsProp [dict get $PropertyDict [lindex [lindex $Groups $i] 1]]

            # SmallStrainUPwDiffOrderElement2D6N
            WriteElements FileVar [lindex $Groups $i] triangle SmallStrainUPwDiffOrderElement2D6N 0 Triangle2D6Connectivities
            # SmallStrainUPwDiffOrderElement2D9N
            WriteElements FileVar [lindex $Groups $i] quadrilateral SmallStrainUPwDiffOrderElement2D9N 0 Quadrilateral2D9Connectivities
            # SmallStrainUPwDiffOrderElement3D10N
            WriteElements FileVar [lindex $Groups $i] tetrahedra SmallStrainUPwDiffOrderElement3D10N 0 Tetrahedron3D10Connectivities
            # SmallStrainUPwDiffOrderElement3D27N
            WriteElements FileVar [lindex $Groups $i] hexahedra SmallStrainUPwDiffOrderElement3D27N 0 Hexahedron3D27Connectivities
        }
    }
    puts $FileVar ""

    ## Conditions
    set ConditionId 0
    set ConditionDict [dict create]
    set Dim [GiD_AccessValue get gendata Domain_Size]
    # Force
    set Groups [GiD_Info conditions Force groups]
    if {$Dim eq 2} {
        # UPwForceCondition2D1N
        WriteNodalConditions FileVar ConditionId ConditionDict $Groups UPwForceCondition2D1N $BodyElemsProp
    } else {
        # UPwForceCondition3D1N
        WriteNodalConditions FileVar ConditionId ConditionDict $Groups UPwForceCondition3D1N $BodyElemsProp
    }
    # Face_Load
    set Groups [GiD_Info conditions Face_Load groups]
    if {$Dim eq 2} {
        if {$IsQuadratic eq 0} {
            # UPwFaceLoadCondition2D2N
            WriteFaceConditions FileVar ConditionId ConditionDict $Groups UPwFaceLoadCondition2D2N $PropertyDict
        } else {
            # LineLoadDiffOrderCondition2D3N
            WriteFaceConditions FileVar ConditionId ConditionDict $Groups LineLoadDiffOrderCondition2D3N $PropertyDict
        }
    } else {
        if {$IsQuadratic eq 0} {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                set MyConditionList [list]
                # UPwFaceLoadCondition3D3N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra UPwFaceLoadCondition3D3N $PropertyDict
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] prism UPwFaceLoadCondition3D3N $PropertyDict
                # UPwFaceLoadCondition3D4N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra UPwFaceLoadCondition3D4N $PropertyDict
                dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
            }
        } elseif {$IsQuadratic eq 1} {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                set MyConditionList [list]
                # SurfaceLoadDiffOrderCondition3D6N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra SurfaceLoadDiffOrderCondition3D6N $PropertyDict
                # SurfaceLoadDiffOrderCondition3D8N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra SurfaceLoadDiffOrderCondition3D8N $PropertyDict
                dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
            }
        } else {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                set MyConditionList [list]
                # SurfaceLoadDiffOrderCondition3D6N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra SurfaceLoadDiffOrderCondition3D6N $PropertyDict
                # SurfaceLoadDiffOrderCondition3D9N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra SurfaceLoadDiffOrderCondition3D9N $PropertyDict
                dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
            }
        }
    }
    # Face_Load_Control_Module
    set Groups [GiD_Info conditions Face_Load_Control_Module groups]
    if {$Dim eq 2} {
        if {$IsQuadratic eq 0} {
            # UPwFaceLoadCondition2D2N
            WriteFaceConditions FileVar ConditionId ConditionDict $Groups UPwFaceLoadCondition2D2N $PropertyDict
        } else {
            # LineLoadDiffOrderCondition2D3N
            WriteFaceConditions FileVar ConditionId ConditionDict $Groups LineLoadDiffOrderCondition2D3N $PropertyDict
        }
    } else {
        if {$IsQuadratic eq 0} {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                set MyConditionList [list]
                # UPwFaceLoadCondition3D3N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra UPwFaceLoadCondition3D3N $PropertyDict
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] prism UPwFaceLoadCondition3D3N $PropertyDict
                # UPwFaceLoadCondition3D4N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra UPwFaceLoadCondition3D4N $PropertyDict
                dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
            }
        } elseif {$IsQuadratic eq 1} {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                set MyConditionList [list]
                # SurfaceLoadDiffOrderCondition3D6N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra SurfaceLoadDiffOrderCondition3D6N $PropertyDict
                # SurfaceLoadDiffOrderCondition3D8N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra SurfaceLoadDiffOrderCondition3D8N $PropertyDict
                dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
            }
        } else {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                set MyConditionList [list]
                # SurfaceLoadDiffOrderCondition3D6N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra SurfaceLoadDiffOrderCondition3D6N $PropertyDict
                # SurfaceLoadDiffOrderCondition3D9N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra SurfaceLoadDiffOrderCondition3D9N $PropertyDict
                dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
            }
        }
    }
    # Normal_Load
    set Groups [GiD_Info conditions Normal_Load groups]
    if {$Dim eq 2} {
        if {$IsQuadratic eq 0} {
            # UPwNormalFaceLoadCondition2D2N
            WriteFaceConditions FileVar ConditionId ConditionDict $Groups UPwNormalFaceLoadCondition2D2N $PropertyDict
        } else {
            # LineNormalLoadDiffOrderCondition2D3N
            WriteFaceConditions FileVar ConditionId ConditionDict $Groups LineNormalLoadDiffOrderCondition2D3N $PropertyDict
        }
    } else {
        if {$IsQuadratic eq 0} {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                set MyConditionList [list]
                # UPwNormalFaceLoadCondition3D3N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra UPwNormalFaceLoadCondition3D3N $PropertyDict
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] prism UPwNormalFaceLoadCondition3D3N $PropertyDict
                # UpwNormalFaceLoadCondition3D4N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra UpwNormalFaceLoadCondition3D4N $PropertyDict
                dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
            }
        } elseif {$IsQuadratic eq 1} {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                set MyConditionList [list]
                # SurfaceNormalLoadDiffOrderCondition3D6N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra SurfaceNormalLoadDiffOrderCondition3D6N $PropertyDict
                # SurfaceNormalLoadDiffOrderCondition3D8N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra SurfaceNormalLoadDiffOrderCondition3D8N $PropertyDict
                dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
            }
        } else {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                set MyConditionList [list]
                # SurfaceNormalLoadDiffOrderCondition3D6N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra SurfaceNormalLoadDiffOrderCondition3D6N $PropertyDict
                # SurfaceNormalLoadDiffOrderCondition3D9N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra SurfaceNormalLoadDiffOrderCondition3D9N $PropertyDict
                dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
            }
        }
    }
    # Normal_Liquid_Flux
    set Groups [GiD_Info conditions Normal_Liquid_Flux groups]
    if {$Dim eq 2} {
        if {$IsQuadratic eq 0} {
            if {$FIC eq false} {
                # UPwNormalLiquidFluxCondition2D2N
                WriteFaceConditions FileVar ConditionId ConditionDict $Groups UPwNormalLiquidFluxCondition2D2N $PropertyDict
            } else {
                # UPwNormalLiquidFluxFICCondition2D2N
                WriteFaceConditions FileVar ConditionId ConditionDict $Groups UPwNormalLiquidFluxFICCondition2D2N $PropertyDict
            }
        } else {
            # LineNormalLiquidFluxDiffOrderCondition2D3N
            WriteFaceConditions FileVar ConditionId ConditionDict $Groups LineNormalLiquidFluxDiffOrderCondition2D3N $PropertyDict
        }
    } else {
        if {$IsQuadratic eq 0} {
            if {$FIC eq false} {
                for {set i 0} {$i < [llength $Groups]} {incr i} {
                    set MyConditionList [list]
                    # UPwNormalLiquidFluxCondition3D3N
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra UPwNormalLiquidFluxCondition3D3N $PropertyDict
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] prism UPwNormalLiquidFluxCondition3D3N $PropertyDict
                    # UPwNormalLiquidFluxCondition3D4N
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra UPwNormalLiquidFluxCondition3D4N $PropertyDict
                    dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
                }
            } else {
                for {set i 0} {$i < [llength $Groups]} {incr i} {
                    set MyConditionList [list]
                    # UPwNormalLiquidFluxFICCondition3D3N
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra UPwNormalLiquidFluxFICCondition3D3N $PropertyDict
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] prism UPwNormalLiquidFluxFICCondition3D3N $PropertyDict
                    # UPwNormalLiquidFluxFICCondition3D4N
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra UPwNormalLiquidFluxFICCondition3D4N $PropertyDict
                    dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
                }
            }
        } elseif {$IsQuadratic eq 1} {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                set MyConditionList [list]
                # SurfaceNormalLiquidFluxDiffOrderCondition3D6N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra SurfaceNormalLiquidFluxDiffOrderCondition3D6N $PropertyDict
                # SurfaceNormalLiquidFluxDiffOrderCondition3D8N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra SurfaceNormalLiquidFluxDiffOrderCondition3D8N $PropertyDict
                dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
            }
        } else {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                set MyConditionList [list]
                # SurfaceNormalLiquidFluxDiffOrderCondition3D6N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra SurfaceNormalLiquidFluxDiffOrderCondition3D6N $PropertyDict
                # SurfaceNormalLiquidFluxDiffOrderCondition3D9N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra SurfaceNormalLiquidFluxDiffOrderCondition3D9N $PropertyDict
                dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
            }
        }
    }
    # Normal_Gas_Flux
    set Groups [GiD_Info conditions Normal_Gas_Flux groups]
    if {$Dim eq 2} {
        if {$IsQuadratic eq 0} {
            if {$FIC eq false} {
                # UPwNormalGasFluxCondition2D2N
                WriteFaceConditions FileVar ConditionId ConditionDict $Groups UPwNormalGasFluxCondition2D2N $PropertyDict
            } else {
                # UPwNormalGasFluxFICCondition2D2N
                WriteFaceConditions FileVar ConditionId ConditionDict $Groups UPwNormalGasFluxFICCondition2D2N $PropertyDict
            }
        } else {
            # LineNormalGasFluxDiffOrderCondition2D3N
            WriteFaceConditions FileVar ConditionId ConditionDict $Groups LineNormalGasFluxDiffOrderCondition2D3N $PropertyDict
        }
    } else {
        if {$IsQuadratic eq 0} {
            if {$FIC eq false} {
                for {set i 0} {$i < [llength $Groups]} {incr i} {
                    set MyConditionList [list]
                    # UPwNormalGasFluxCondition3D3N
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra UPwNormalGasFluxCondition3D3N $PropertyDict
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] prism UPwNormalGasFluxCondition3D3N $PropertyDict
                    # UPwNormalGasFluxCondition3D4N
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra UPwNormalGasFluxCondition3D4N $PropertyDict
                    dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
                }
            } else {
                for {set i 0} {$i < [llength $Groups]} {incr i} {
                    set MyConditionList [list]
                    # UPwNormalGasFluxFICCondition3D3N
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra UPwNormalGasFluxFICCondition3D3N $PropertyDict
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] prism UPwNormalGasFluxFICCondition3D3N $PropertyDict
                    # UPwNormalGasFluxFICCondition3D4N
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra UPwNormalGasFluxFICCondition3D4N $PropertyDict
                    dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
                }
            }
        } elseif {$IsQuadratic eq 1} {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                set MyConditionList [list]
                # SurfaceNormalGasFluxDiffOrderCondition3D6N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra SurfaceNormalGasFluxDiffOrderCondition3D6N $PropertyDict
                # SurfaceNormalGasFluxDiffOrderCondition3D8N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra SurfaceNormalGasFluxDiffOrderCondition3D8N $PropertyDict
                dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
            }
        } else {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                set MyConditionList [list]
                # SurfaceNormalGasFluxDiffOrderCondition3D6N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra SurfaceNormalGasFluxDiffOrderCondition3D6N $PropertyDict
                # SurfaceNormalGasFluxDiffOrderCondition3D9N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra SurfaceNormalGasFluxDiffOrderCondition3D9N $PropertyDict
                dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
            }
        }
    }

    puts $FileVar ""

    ## SubModelParts
    # Body_Part
    WriteElementSubmodelPart FileVar Body_Part
    # Solid_Displacement
    WriteConstraintSubmodelPart FileVar Solid_Displacement $TableDict
    # Liquid_Pressure
    WriteConstraintSubmodelPart FileVar Liquid_Pressure $TableDict
    # Gas_Pressure
    WriteConstraintSubmodelPart FileVar Gas_Pressure $TableDict
    # Force
    WriteLoadSubmodelPart FileVar Force $TableDict $ConditionDict
    # Face_Load
    WriteLoadSubmodelPart FileVar Face_Load $TableDict $ConditionDict
    # Face_Load_Control_Module
    WriteLoadSubmodelPart FileVar Face_Load_Control_Module $TableDict $ConditionDict
    # Normal_Load
    WriteLoadSubmodelPart FileVar Normal_Load $TableDict $ConditionDict
    # Normal_Liquid_Flux
    WriteLoadSubmodelPart FileVar Normal_Liquid_Flux $TableDict $ConditionDict
    # Normal_Gas_Flux
    WriteLoadSubmodelPart FileVar Normal_Gas_Flux $TableDict $ConditionDict
    # Body_Acceleration
    WriteConstraintSubmodelPart FileVar Body_Acceleration $TableDict

    close $FileVar

    set MDPAOutput [list $PropertyId $TableDict]

    return $MDPAOutput
}