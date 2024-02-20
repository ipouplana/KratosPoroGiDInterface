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
    # Force
    VectorTable FileVar TableId TableDict Force FORCE
    # Face_Load
    VectorTable FileVar TableId TableDict Face_Load FACE_LOAD
    # Face_Load_Control_Module
    VectorTable FileVar TableId TableDict Face_Load_Control_Module FACE_LOAD
    # Normal_Load
    NormalTangentialTable FileVar TableId TableDict Normal_Load NORMAL_CONTACT_STRESS TANGENTIAL_CONTACT_STRESS
    # Liquid_Discharge
    ScalarTable FileVar TableId TableDict Liquid_Discharge LIQUID_DISCHARGE
    # Normal_Liquid_Flux
    ScalarTable FileVar TableId TableDict Normal_Liquid_Flux NORMAL_LIQUID_FLUX
    # Interface_Face_Load
    VectorTable FileVar TableId TableDict Interface_Face_Load FACE_LOAD
    # Interface_Normal_Liquid_Flux
    ScalarTable FileVar TableId TableDict Interface_Normal_Liquid_Flux NORMAL_LIQUID_FLUX
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
        incr PropertyId
        dict set PropertyDict [lindex [lindex $Groups $i] 1] $PropertyId
        puts $FileVar "Begin Properties $PropertyId"
        if {[lindex [lindex $Groups $i] 3] eq "LinearElasticSolid3DLaw"} {
            if { ([GiD_AccessValue get gendata Initial_Stresses] eq false) || (([GiD_AccessValue get gendata Initial_Stresses] eq true) && ([GiD_AccessValue get gendata Mode] eq "save")) } {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME [lindex [lindex $Groups $i] 3]"
            } else {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME HistoryLinearElastic3DLaw"
            }
        } elseif {[lindex [lindex $Groups $i] 3] eq "LinearElasticPlaneStrainSolid2DLaw"} {
            if { ([GiD_AccessValue get gendata Initial_Stresses] eq false) || (([GiD_AccessValue get gendata Initial_Stresses] eq true) && ([GiD_AccessValue get gendata Mode] eq "save")) } {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME [lindex [lindex $Groups $i] 3]"
            } else {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME HistoryLinearElasticPlaneStrain2DLaw"
            }
        } elseif {[lindex [lindex $Groups $i] 3] eq "LinearElasticPlaneStressSolid2DLaw"} {
            if { ([GiD_AccessValue get gendata Initial_Stresses] eq false) || (([GiD_AccessValue get gendata Initial_Stresses] eq true) && ([GiD_AccessValue get gendata Mode] eq "save")) } {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME [lindex [lindex $Groups $i] 3]"
            } else {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME HistoryLinearElasticPlaneStress2DLaw"
            }
        } elseif {[lindex [lindex $Groups $i] 3] eq "SimoJuDamage3DLaw"} {
            if {[GiD_AccessValue get gendata Non-local_Damage] eq true} {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME SimoJuNonlocalDamage3DLaw"
            } else {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME SimoJuLocalDamage3DLaw"
            }
        } elseif {[lindex [lindex $Groups $i] 3] eq "SimoJuDamagePlaneStrain2DLaw"} {
            if {[GiD_AccessValue get gendata Non-local_Damage] eq true} {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME SimoJuNonlocalDamagePlaneStrain2DLaw"
            } else {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME SimoJuLocalDamagePlaneStrain2DLaw"
            }
        } elseif {[lindex [lindex $Groups $i] 3] eq "SimoJuDamagePlaneStress2DLaw"} {
            if {[GiD_AccessValue get gendata Non-local_Damage] eq true} {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME SimoJuNonlocalDamagePlaneStress2DLaw"
            } else {
                puts $FileVar "  CONSTITUTIVE_LAW_NAME SimoJuLocalDamagePlaneStress2DLaw"
            }
        } elseif {[lindex [lindex $Groups $i] 3] eq "ModifiedMisesDamage3DLaw"} {
            puts $FileVar "  CONSTITUTIVE_LAW_NAME ModifiedMisesNonlocalDamage3DLaw"
        } elseif {[lindex [lindex $Groups $i] 3] eq "ModifiedMisesDamagePlaneStrain2DLaw"} {
            puts $FileVar "  CONSTITUTIVE_LAW_NAME ModifiedMisesNonlocalDamagePlaneStrain2DLaw"
        } elseif {[lindex [lindex $Groups $i] 3] eq "ModifiedMisesDamagePlaneStress2DLaw"} {
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
        puts $FileVar "  PERMEABILITY_ZZ [lindex [lindex $Groups $i] 13]"
        puts $FileVar "  PERMEABILITY_XY [lindex [lindex $Groups $i] 14]"
        puts $FileVar "  PERMEABILITY_YZ [lindex [lindex $Groups $i] 15]"
        puts $FileVar "  PERMEABILITY_ZX [lindex [lindex $Groups $i] 16]"
        puts $FileVar "  DYNAMIC_VISCOSITY_LIQUID [lindex [lindex $Groups $i] 17]"
        puts $FileVar "  BIOT_COEFFICIENT [lindex [lindex $Groups $i] 18]"
        puts $FileVar "  THICKNESS [lindex [lindex $Groups $i] 19]"
        puts $FileVar "  DAMAGE_THRESHOLD [lindex [lindex $Groups $i] 20]"
        puts $FileVar "  STRENGTH_RATIO [lindex [lindex $Groups $i] 21]"
        puts $FileVar "  FRACTURE_ENERGY [lindex [lindex $Groups $i] 22]"
        puts $FileVar "  RESIDUAL_STRENGTH [lindex [lindex $Groups $i] 23]"
        puts $FileVar "  SOFTENING_SLOPE [lindex [lindex $Groups $i] 24]"
        puts $FileVar "End Properties"
        puts $FileVar ""
    }
    # Interface_Part
    set Groups [GiD_Info conditions Interface_Part groups]
    for {set i 0} {$i < [llength $Groups]} {incr i} {
        incr PropertyId
        dict set PropertyDict [lindex [lindex $Groups $i] 1] $PropertyId
        puts $FileVar "Begin Properties $PropertyId"
        if {[lindex [lindex $Groups $i] 4] eq "BilinearCohesive3DLaw" || [lindex [lindex $Groups $i] 4] eq "ExponentialCohesive3DLaw"} {
            puts $FileVar "  CONSTITUTIVE_LAW_NAME [lindex [lindex $Groups $i] 4]"
        } elseif {[lindex [lindex $Groups $i] 4] eq "BilinearCohesivePlaneStrain2DLaw" || [lindex [lindex $Groups $i] 4] eq "BilinearCohesivePlaneStress2DLaw"} {
            puts $FileVar "  CONSTITUTIVE_LAW_NAME BilinearCohesive2DLaw"
        } elseif {[lindex [lindex $Groups $i] 4] eq "ExponentialCohesivePlaneStrain2DLaw" || [lindex [lindex $Groups $i] 4] eq "ExponentialCohesivePlaneStress2DLaw"} {
            puts $FileVar "  ExponentialCohesive2DLaw"
        } elseif {[lindex [lindex $Groups $i] 4] eq "ElasticCohesive3DLaw"} {
            puts $FileVar "  ElasticCohesive3DLaw"
        } elseif {[lindex [lindex $Groups $i] 4] eq "ElasticCohesive2DLaw"} {
            puts $FileVar "  ElasticCohesive2DLaw"
        } elseif {[lindex [lindex $Groups $i] 4] eq "IsotropicDamageCohesive2DLaw"} {
            puts $FileVar "  IsotropicDamageCohesive2DLaw"
        } elseif {[lindex [lindex $Groups $i] 4] eq "IsotropicDamageCohesive3DLaw"} {
            puts $FileVar "  IsotropicDamageCohesive3DLaw"
        } elseif {[lindex [lindex $Groups $i] 4] eq "ElastoPlasticModMohrCoulombCohesive3DLaw"} {
            puts $FileVar "  ElastoPlasticModMohrCoulombCohesive3DLaw"
        } elseif {[lindex [lindex $Groups $i] 4] eq "ElastoPlasticModMohrCoulombCohesive2DLaw"} {
            puts $FileVar "  ElastoPlasticModMohrCoulombCohesive2DLaw"
        } elseif {[lindex [lindex $Groups $i] 4] eq "ElastoPlasticMohrCoulombCohesive3DLaw"} {
            puts $FileVar "  ElastoPlasticMohrCoulombCohesive3DLaw"
        } elseif {[lindex [lindex $Groups $i] 4] eq "ElastoPlasticMohrCoulombCohesive2DLaw"} {
            puts $FileVar "  ElastoPlasticMohrCoulombCohesive2DLaw"
        }
        if {[lindex [lindex $Groups $i] 5] eq "Linear"} {
            puts $FileVar "  DAMAGE_EVOLUTION_LAW 1"
        } elseif {[lindex [lindex $Groups $i] 5] eq "Exponential"} {
            puts $FileVar "  DAMAGE_EVOLUTION_LAW 2"
        }
        puts $FileVar "  NORMAL_STIFFNESS [lindex [lindex $Groups $i] 6]"
        puts $FileVar "  SHEAR_STIFFNESS\": [lindex [lindex $Groups $i] 7]"
        puts $FileVar "  PENALTY_STIFFNESS\": [lindex [lindex $Groups $i] 8]"
        puts $FileVar "  YOUNG_MODULUS\": [lindex [lindex $Groups $i] 9]"
        puts $FileVar "  POISSON_RATIO\": [lindex [lindex $Groups $i] 10]"
        puts $FileVar "  DENSITY_SOLID\": [lindex [lindex $Groups $i] 11]"
        puts $FileVar "  DENSITY_LIQUID\": [lindex [lindex $Groups $i] 12]"
        puts $FileVar "  POROSITY\": [lindex [lindex $Groups $i] 13]"
        puts $FileVar "  BULK_MODULUS_SOLID\": [lindex [lindex $Groups $i] 14]"
        puts $FileVar "  BULK_MODULUS_LIQUID\": [lindex [lindex $Groups $i] 15]"
        puts $FileVar "  TRANSVERSAL_PERMEABILITY_COEFFICIENT\": [lindex [lindex $Groups $i] 16]"
        puts $FileVar "  DYNAMIC_VISCOSITY_LIQUID\": [lindex [lindex $Groups $i] 17]"
        puts $FileVar "  BIOT_COEFFICIENT\": [lindex [lindex $Groups $i] 18]"
        puts $FileVar "  THICKNESS\": [lindex [lindex $Groups $i] 19]"
        puts $FileVar "  DAMAGE_THRESHOLD\": [lindex [lindex $Groups $i] 20]"
        puts $FileVar "  INITIAL_JOINT_WIDTH\": [lindex [lindex $Groups $i] 21]"
        puts $FileVar "  CRITICAL_DISPLACEMENT\": [lindex [lindex $Groups $i] 22]"
        puts $FileVar "  YIELD_STRESS\": [lindex [lindex $Groups $i] 23]"
        puts $FileVar "  FRICTION_COEFFICIENT\": [lindex [lindex $Groups $i] 24]"
        puts $FileVar "  FRACTURE_ENERGY\": [lindex [lindex $Groups $i] 25]"
        puts $FileVar "  SHEAR_FRACTURE_ENERGY\": [lindex [lindex $Groups $i] 26]"
        puts $FileVar "  TENSILE_STRENGTH\": [lindex [lindex $Groups $i] 27]"
        puts $FileVar "  BETA_EQSTRAIN_SHEAR_FACTOR\": [lindex [lindex $Groups $i] 28]"
        puts $FileVar "  FRICTION_ANGLE\": [lindex [lindex $Groups $i] 29]"
        puts $FileVar "  COHESION\": [lindex [lindex $Groups $i] 30]"
        puts $FileVar "  DILATANCY_ANGLE\": [lindex [lindex $Groups $i] 31]"
        puts $FileVar "  STATE_VARIABLE\": [lindex [lindex $Groups $i] 32]"
        puts $FileVar "  TAU\": [lindex [lindex $Groups $i] 33]"
        puts $FileVar "  CURVE_FITTING_ETA\": [lindex [lindex $Groups $i] 34]"
        puts $FileVar "End Properties"
        puts $FileVar ""
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

                # UPlSmallStrainElement2D3N
                WriteElements FileVar [lindex $Groups $i] triangle UPlSmallStrainElement2D3N 0 Triangle2D3Connectivities
                # UPlSmallStrainElement2D4N
                WriteElements FileVar [lindex $Groups $i] quadrilateral UPlSmallStrainElement2D4N 0 Quadrilateral2D4Connectivities
                # UPlSmallStrainElement3D4N
                WriteElements FileVar [lindex $Groups $i] tetrahedra UPlSmallStrainElement3D4N 0 Quadrilateral2D4Connectivities
                # UPlSmallStrainElement3D8N
                WriteElements FileVar [lindex $Groups $i] hexahedra UPlSmallStrainElement3D8N 0 Hexahedron3D8Connectivities
            }
        } else {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                # Elements Property
                set BodyElemsProp [dict get $PropertyDict [lindex [lindex $Groups $i] 1]]

                # UPlSmallStrainFICElement2D3N
                WriteElements FileVar [lindex $Groups $i] triangle UPlSmallStrainFICElement2D3N 0 Triangle2D3Connectivities
                # UPlSmallStrainFICElement2D4N
                WriteElements FileVar [lindex $Groups $i] quadrilateral UPlSmallStrainFICElement2D4N 0 Quadrilateral2D4Connectivities
                # UPlSmallStrainFICElement3D4N
                WriteElements FileVar [lindex $Groups $i] tetrahedra UPlSmallStrainFICElement3D4N 0 Quadrilateral2D4Connectivities
                # UPlSmallStrainFICElement3D8N
                WriteElements FileVar [lindex $Groups $i] hexahedra UPlSmallStrainFICElement3D8N 0 Hexahedron3D8Connectivities
            }
        }
    } elseif {$IsQuadratic eq 1} {
        for {set i 0} {$i < [llength $Groups]} {incr i} {
            # Elements Property
            set BodyElemsProp [dict get $PropertyDict [lindex [lindex $Groups $i] 1]]

            # SmallStrainUPlDiffOrderElement2D6N
            WriteElements FileVar [lindex $Groups $i] triangle SmallStrainUPlDiffOrderElement2D6N 0 Triangle2D6Connectivities
            # SmallStrainUPlDiffOrderElement2D8N
            WriteElements FileVar [lindex $Groups $i] quadrilateral SmallStrainUPlDiffOrderElement2D8N 0 Hexahedron3D8Connectivities
            # SmallStrainUPlDiffOrderElement3D10N
            WriteElements FileVar [lindex $Groups $i] tetrahedra SmallStrainUPlDiffOrderElement3D10N 0 Tetrahedron3D10Connectivities
            # SmallStrainUPlDiffOrderElement3D20N
            WriteElements FileVar [lindex $Groups $i] hexahedra SmallStrainUPlDiffOrderElement3D20N 0 Hexahedron3D20Connectivities
        }
    } else {
        for {set i 0} {$i < [llength $Groups]} {incr i} {
            # Elements Property
            set BodyElemsProp [dict get $PropertyDict [lindex [lindex $Groups $i] 1]]

            # SmallStrainUPlDiffOrderElement2D6N
            WriteElements FileVar [lindex $Groups $i] triangle SmallStrainUPlDiffOrderElement2D6N 0 Triangle2D6Connectivities
            # SmallStrainUPlDiffOrderElement2D9N
            WriteElements FileVar [lindex $Groups $i] quadrilateral SmallStrainUPlDiffOrderElement2D9N 0 Quadrilateral2D9Connectivities
            # SmallStrainUPlDiffOrderElement3D10N
            WriteElements FileVar [lindex $Groups $i] tetrahedra SmallStrainUPlDiffOrderElement3D10N 0 Tetrahedron3D10Connectivities
            # SmallStrainUPlDiffOrderElement3D27N
            WriteElements FileVar [lindex $Groups $i] hexahedra SmallStrainUPlDiffOrderElement3D27N 0 Hexahedron3D27Connectivities
        }
    }
    # Interface_Part
    set Groups [GiD_Info conditions Interface_Part groups]
    for {set i 0} {$i < [llength $Groups]} {incr i} {
        if {[lindex [lindex $Groups $i] 3] eq false} {
            # Elements Property
            set InterfaceElemsProp [dict get $PropertyDict [lindex [lindex $Groups $i] 1]]
            # UPlSmallStrainInterfaceElement2D4N
            WriteElements FileVar [lindex $Groups $i] quadrilateral UPlSmallStrainInterfaceElement2D4N 0 Quadrilateral2D4Connectivities
            # UPlSmallStrainInterfaceElement3D6N
            WriteElements FileVar [lindex $Groups $i] prism UPlSmallStrainInterfaceElement3D6N 0 PrismInterface3D6Connectivities
            # UPlSmallStrainInterfaceElement3D8N
            WriteElements FileVar [lindex $Groups $i] hexahedra UPlSmallStrainInterfaceElement3D8N 0 HexahedronInterface3D8Connectivities
        } else {
            # Elements Property
            set LinkInterfaceElemsProp [dict get $PropertyDict [lindex [lindex $Groups $i] 1]]
            # UPlSmallStrainLinkInterfaceElement2D4N
            WriteElements FileVar [lindex $Groups $i] quadrilateral UPlSmallStrainLinkInterfaceElement2D4N 0 QuadrilateralInterface2D4Connectivities
            WriteElements FileVar [lindex $Groups $i] triangle UPlSmallStrainLinkInterfaceElement2D4N 0 TriangleInterface2D4Connectivities
            # UPlSmallStrainLinkInterfaceElement3D6N
            WriteElements FileVar [lindex $Groups $i] prism UPlSmallStrainLinkInterfaceElement3D6N 0 Triangle2D6Connectivities
            WriteElements FileVar [lindex $Groups $i] tetrahedra UPlSmallStrainLinkInterfaceElement3D6N 0 TetrahedronInterface3D6Connectivities
            # UPlSmallStrainLinkInterfaceElement3D8N
            WriteElements FileVar [lindex $Groups $i] hexahedra UPlSmallStrainLinkInterfaceElement3D8N 0 Hexahedron3D8Connectivities
        }
    }
    # PropagationUnion (InterfaceElement)
    if {[GiD_Groups exists PropagationUnion_3d_6] eq 1} {
        # UPlSmallStrainInterfaceElement3D6N
        set PropUnionElementList [WritePropUnionElements FileVar $InterfaceElemsProp]
    }
    puts $FileVar ""

    ## Conditions
    set ConditionId 0
    set ConditionDict [dict create]
    set Dim [GiD_AccessValue get gendata Domain_Size]
    # Force
    set Groups [GiD_Info conditions Force groups]
    if {$Dim eq 2} {
        # UPlForceCondition2D1N
        WriteNodalConditions FileVar ConditionId ConditionDict $Groups UPlForceCondition2D1N $BodyElemsProp
    } else {
        # UPlForceCondition3D1N
        WriteNodalConditions FileVar ConditionId ConditionDict $Groups UPlForceCondition3D1N $BodyElemsProp
    }
    # Face_Load
    set Groups [GiD_Info conditions Face_Load groups]
    if {$Dim eq 2} {
        if {$IsQuadratic eq 0} {
            # UPlFaceLoadCondition2D2N
            WriteFaceConditions FileVar ConditionId ConditionDict $Groups UPlFaceLoadCondition2D2N $PropertyDict
        } else {
            # LineLoadDiffOrderCondition2D3N
            WriteFaceConditions FileVar ConditionId ConditionDict $Groups LineLoadDiffOrderCondition2D3N $PropertyDict
        }
    } else {
        if {$IsQuadratic eq 0} {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                set MyConditionList [list]
                # UPlFaceLoadCondition3D3N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra UPlFaceLoadCondition3D3N $PropertyDict
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] prism UPlFaceLoadCondition3D3N $PropertyDict
                # UPlFaceLoadCondition3D4N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra UPlFaceLoadCondition3D4N $PropertyDict
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
            # UPlFaceLoadCondition2D2N
            WriteFaceConditions FileVar ConditionId ConditionDict $Groups UPlFaceLoadCondition2D2N $PropertyDict
        } else {
            # LineLoadDiffOrderCondition2D3N
            WriteFaceConditions FileVar ConditionId ConditionDict $Groups LineLoadDiffOrderCondition2D3N $PropertyDict
        }
    } else {
        if {$IsQuadratic eq 0} {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                set MyConditionList [list]
                # UPlFaceLoadCondition3D3N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra UPlFaceLoadCondition3D3N $PropertyDict
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] prism UPlFaceLoadCondition3D3N $PropertyDict
                # UPlFaceLoadCondition3D4N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra UPlFaceLoadCondition3D4N $PropertyDict
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
            # UPlNormalFaceLoadCondition2D2N
            WriteFaceConditions FileVar ConditionId ConditionDict $Groups UPlNormalFaceLoadCondition2D2N $PropertyDict
        } else {
            # LineNormalLoadDiffOrderCondition2D3N
            WriteFaceConditions FileVar ConditionId ConditionDict $Groups LineNormalLoadDiffOrderCondition2D3N $PropertyDict
        }
    } else {
        if {$IsQuadratic eq 0} {
            for {set i 0} {$i < [llength $Groups]} {incr i} {
                set MyConditionList [list]
                # UPlNormalFaceLoadCondition3D3N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra UPlNormalFaceLoadCondition3D3N $PropertyDict
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] prism UPlNormalFaceLoadCondition3D3N $PropertyDict
                # UPlNormalFaceLoadCondition3D4N
                WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra UPlNormalFaceLoadCondition3D4N $PropertyDict
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

    # Liquid_Discharge
    set Groups [GiD_Info conditions Liquid_Discharge groups]
    if {$Dim eq 2} {
        # UPlDischargeCondition2D1N
        WriteNodalConditions FileVar ConditionId ConditionDict $Groups UPlDischargeCondition2D1N $BodyElemsProp
    } else {
        # UPlDischargeCondition3D1N
        WriteNodalConditions FileVar ConditionId ConditionDict $Groups UPlDischargeCondition3D1N $BodyElemsProp
    }
    # Normal_Liquid_Flux
    set Groups [GiD_Info conditions Normal_Liquid_Flux groups]
    if {$Dim eq 2} {
        if {$IsQuadratic eq 0} {
            if {$FIC eq false} {
                # UPlNormalLiquidFluxCondition2D2N
                WriteFaceConditions FileVar ConditionId ConditionDict $Groups UPlNormalLiquidFluxCondition2D2N $PropertyDict
            } else {
                # UPlNormalLiquidFluxFICCondition2D2N
                WriteFaceConditions FileVar ConditionId ConditionDict $Groups UPlNormalLiquidFluxFICCondition2D2N $PropertyDict
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
                    # UPlNormalLiquidFluxCondition3D3N
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra UPlNormalLiquidFluxCondition3D3N $PropertyDict
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] prism UPlNormalLiquidFluxCondition3D3N $PropertyDict
                    # UPlNormalLiquidFluxCondition3D4N
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra UPlNormalLiquidFluxCondition3D4N $PropertyDict
                    dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
                }
            } else {
                for {set i 0} {$i < [llength $Groups]} {incr i} {
                    set MyConditionList [list]
                    # UPlNormalLiquidFluxFICCondition3D3N
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] tetrahedra UPlNormalLiquidFluxFICCondition3D3N $PropertyDict
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] prism UPlNormalLiquidFluxFICCondition3D3N $PropertyDict
                    # UPlNormalLiquidFluxFICCondition3D4N
                    WriteTypeFaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] hexahedra UPlNormalLiquidFluxFICCondition3D4N $PropertyDict
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
    # Interface_Face_Load
    set Groups [GiD_Info conditions Interface_Face_Load groups]
    for {set i 0} {$i < [llength $Groups]} {incr i} {
        set MyConditionList [list]
        # UPlFaceLoadInterfaceCondition2D2N
        WriteInterfaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] linear UPlFaceLoadInterfaceCondition2D2N $InterfaceElemsProp Line2D2Connectivities
        # UPlFaceLoadInterfaceCondition3D4N
        WriteInterfaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] triangle UPlFaceLoadInterfaceCondition3D4N $InterfaceElemsProp TriangleInterface3D4Connectivities
        WriteInterfaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] quadrilateral UPlFaceLoadInterfaceCondition3D4N $InterfaceElemsProp QuadrilateralInterface3D4Connectivities
        dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
    }
    # Interface_Normal_Liquid_Flux
    set Groups [GiD_Info conditions Interface_Normal_Liquid_Flux groups]
    for {set i 0} {$i < [llength $Groups]} {incr i} {
        set MyConditionList [list]
        # UPlNormalLiquidFluxInterfaceCondition2D2N
        WriteInterfaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] linear UPlNormalLiquidFluxInterfaceCondition2D2N $InterfaceElemsProp Line2D2Connectivities
        # UPlNormalLiquidFluxInterfaceCondition3D4N
        WriteInterfaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] triangle UPlNormalLiquidFluxInterfaceCondition3D4N $InterfaceElemsProp TriangleInterface3D4Connectivities
        WriteInterfaceConditions FileVar ConditionId MyConditionList [lindex $Groups $i] quadrilateral UPlNormalLiquidFluxInterfaceCondition3D4N $InterfaceElemsProp QuadrilateralInterface3D4Connectivities
        dict set ConditionDict [lindex [lindex $Groups $i] 1] $MyConditionList
    }

    # Periodic_Bars
    set IsPeriodic [GiD_AccessValue get gendata Periodic_Interface_Conditions]
    if {$IsPeriodic eq true} {
        set PeriodicBarsDict [dict create]
        set Groups [GiD_Info conditions Interface_Part groups]
        for {set i 0} {$i < [llength $Groups]} {incr i} {
            if {[lindex [lindex $Groups $i] 20] eq true} {
                # Elements Property
                set InterfaceElemsProp [dict get $PropertyDict [lindex [lindex $Groups $i] 1]]
                set ConditionList [list]
                # InterfaceElement2D4N
                SavePeriodicBarsFromIE2D4N PeriodicBarsDict ConditionId ConditionList [lindex $Groups $i] $InterfaceElemsProp
                # InterfaceElement3D6N
                SavePeriodicBarsFromIE3D6N PeriodicBarsDict ConditionId ConditionList [lindex $Groups $i] $InterfaceElemsProp
                # InterfaceElement3D8N
                SavePeriodicBarsFromIE3D8N PeriodicBarsDict ConditionId ConditionList [lindex $Groups $i] $InterfaceElemsProp

                dict set ConditionDict Periodic_Bars_[lindex [lindex $Groups $i] 1] $ConditionList
            }
        }

        if {[dict size $PeriodicBarsDict] > 0} {
            puts $FileVar "Begin Conditions PeriodicCondition"
            dict for {Name PeriodicBar} $PeriodicBarsDict {
                puts $FileVar "  [dict get $PeriodicBar Id]  [dict get $PeriodicBar PropertyId]  [dict get $PeriodicBar Connectivities]"
            }
            puts $FileVar "End Conditions"
            puts $FileVar ""
        }
    }

    puts $FileVar ""

    ## SubModelParts
    # Body_Part
    WriteElementSubmodelPart FileVar Body_Part
    # Interface_Part
    WriteElementSubmodelPart FileVar Interface_Part
    # PropagationUnion (InterfaceElement)
    if {[GiD_Groups exists PropagationUnion_3d_6] eq 1} {
        WritePropUnionElementSubmodelPart FileVar $PropUnionElementList
    }
    # Solid_Displacement
    WriteConstraintSubmodelPart FileVar Solid_Displacement $TableDict
    # Liquid_Pressure
    WriteConstraintSubmodelPart FileVar Liquid_Pressure $TableDict
    # Force
    WriteLoadSubmodelPart FileVar Force $TableDict $ConditionDict
    # Face_Load
    WriteLoadSubmodelPart FileVar Face_Load $TableDict $ConditionDict
    # Face_Load_Control_Module
    WriteLoadSubmodelPart FileVar Face_Load_Control_Module $TableDict $ConditionDict
    # Normal_Load
    WriteLoadSubmodelPart FileVar Normal_Load $TableDict $ConditionDict
    # Liquid_Discharge
    WriteLoadSubmodelPart FileVar Liquid_Discharge $TableDict $ConditionDict
    # Normal_Liquid_Flux
    WriteLoadSubmodelPart FileVar Normal_Liquid_Flux $TableDict $ConditionDict
    # Interface_Face_Load
    WriteLoadSubmodelPart FileVar Interface_Face_Load $TableDict $ConditionDict
    # Interface_Normal_Liquid_Flux
    WriteLoadSubmodelPart FileVar Interface_Normal_Liquid_Flux $TableDict $ConditionDict
    # Body_Acceleration
    WriteConstraintSubmodelPart FileVar Body_Acceleration $TableDict

    # Periodic_Bars
    if {$IsPeriodic eq true} {
        WritePeriodicBarsSubmodelPart FileVar Interface_Part $ConditionDict
    }

    close $FileVar

    set MDPAOutput [list $PropertyId $TableDict]

    return $MDPAOutput
}