proc AppendGroupNames {String CondName} {
    upvar $String MyString

    set Groups [GiD_Info conditions $CondName groups]
    for {set i 0} {$i < [llength $Groups]} {incr i} {
        append MyString \" [lindex [lindex $Groups $i] 1] \" ,
    }
}

#-------------------------------------------------------------------------------

proc AppendGroupNamesWithNum {String GroupNum CondName} {
    upvar $String MyString
    upvar $GroupNum MyGroupNum

    set Groups [GiD_Info conditions $CondName groups]
    for {set i 0} {$i < [llength $Groups]} {incr i} {
        incr MyGroupNum
        append MyString \" [lindex [lindex $Groups $i] 1] \" ,
    }
}

#-------------------------------------------------------------------------------

proc AppendGroupVariables {String CondName VarName} {
    upvar $String MyString

    set Groups [GiD_Info conditions $CondName groups]
    for {set i 0} {$i < [llength $Groups]} {incr i} {
        append MyString \" $VarName \" ,
    }
}

#-------------------------------------------------------------------------------

proc AppendOutputVariables {String GroupNum QuestionName VarName} {
    upvar $String MyString
    upvar $GroupNum MyGroupNum

    if {[GiD_AccessValue get gendata $QuestionName] eq true} {
        incr MyGroupNum
        append MyString \" $VarName \" ,
    }
}

#-------------------------------------------------------------------------------

proc WriteFaceLoadControlModuleProcess {FileVar GroupNum Groups TableDict NumGroups} {
    upvar $FileVar MyFileVar
    upvar $GroupNum MyGroupNum

    for {set i 0} {$i < [llength $Groups]} {incr i} {
        incr MyGroupNum
        puts $MyFileVar "            \"python_module\": \"poromechanics_face_load_control_module_process\","
        puts $MyFileVar "            \"kratos_module\": \"KratosMultiphysics.PoromechanicsApplication\","
        puts $MyFileVar "            \"Parameters\":    \{"
        puts $MyFileVar "                \"model_part_name\": \"PorousModelPart.[lindex [lindex $Groups $i] 1]\","
        puts $MyFileVar "                \"initial_velocity\":   [lindex [lindex $Groups $i] 15],"
        puts $MyFileVar "                \"limit_velocity\":   [lindex [lindex $Groups $i] 16],"
        puts $MyFileVar "                \"velocity_factor\":   [lindex [lindex $Groups $i] 17],"
        puts $MyFileVar "                \"initial_stiffness\":   [lindex [lindex $Groups $i] 18],"
        puts $MyFileVar "                \"force_increment_tolerance\":   [lindex [lindex $Groups $i] 19],"
        puts $MyFileVar "                \"update_stiffness\":   [lindex [lindex $Groups $i] 20],"
        puts $MyFileVar "                \"force_averaging_time\":   [lindex [lindex $Groups $i] 21],"
        puts $MyFileVar "                \"active\":          \[[lindex [lindex $Groups $i] 3],[lindex [lindex $Groups $i] 7],[lindex [lindex $Groups $i] 11]\],"
        puts $MyFileVar "                \"table\":           \[[dict get $TableDict [lindex [lindex $Groups $i] 1] Table0],[dict get $TableDict [lindex [lindex $Groups $i] 1] Table1],[dict get $TableDict [lindex [lindex $Groups $i] 1] Table2]\]"
        puts $MyFileVar "            \}"
        if {$MyGroupNum < $NumGroups} {
            puts $MyFileVar "        \},\{"
        } else {
            puts $MyFileVar "        \}\],"
        }
    }
}

#-------------------------------------------------------------------------------

proc WriteConstraintVectorProcess {FileVar GroupNum Groups EntityType VarName TableDict NumGroups} {
    upvar $FileVar MyFileVar
    upvar $GroupNum MyGroupNum

    for {set i 0} {$i < [llength $Groups]} {incr i} {
        set Entities [GiD_EntitiesGroups get [lindex [lindex $Groups $i] 1] $EntityType]
        if {[llength $Entities] > 0} {
            incr MyGroupNum
            puts $MyFileVar "            \"python_module\": \"apply_vector_constraint_table_process\","
            puts $MyFileVar "            \"kratos_module\": \"KratosMultiphysics.PoromechanicsApplication\","
            puts $MyFileVar "            \"Parameters\":    \{"
            puts $MyFileVar "                \"model_part_name\": \"PorousModelPart.[lindex [lindex $Groups $i] 1]\","
            puts $MyFileVar "                \"variable_name\":   \"$VarName\","
            puts $MyFileVar "                \"active\":          \[[lindex [lindex $Groups $i] 3],[lindex [lindex $Groups $i] 8],[lindex [lindex $Groups $i] 13]\],"
            puts $MyFileVar "                \"is_fixed\":        \[[lindex [lindex $Groups $i] 5],[lindex [lindex $Groups $i] 10],[lindex [lindex $Groups $i] 15]\],"
            puts $MyFileVar "                \"value\":           \[[lindex [lindex $Groups $i] 4],[lindex [lindex $Groups $i] 9],[lindex [lindex $Groups $i] 14]\],"
            puts $MyFileVar "                \"table\":           \[[dict get $TableDict [lindex [lindex $Groups $i] 1] Table0],[dict get $TableDict [lindex [lindex $Groups $i] 1] Table1],[dict get $TableDict [lindex [lindex $Groups $i] 1] Table2]\]"
            puts $MyFileVar "            \}"
            if {$MyGroupNum < $NumGroups} {
                puts $MyFileVar "        \},\{"
            } else {
                puts $MyFileVar "        \}\],"
            }
        }
    }
}

#-------------------------------------------------------------------------------

proc WritePressureConstraintProcess {FileVar GroupNum Groups EntityType VarName TableDict NumGroups} {
    upvar $FileVar MyFileVar
    upvar $GroupNum MyGroupNum

    for {set i 0} {$i < [llength $Groups]} {incr i} {
        set Entities [GiD_EntitiesGroups get [lindex [lindex $Groups $i] 1] $EntityType]
        if {[llength $Entities] > 0} {
            incr MyGroupNum
            puts $MyFileVar "            \"python_module\": \"apply_scalar_constraint_table_process\","
            puts $MyFileVar "            \"kratos_module\": \"KratosMultiphysics.PoromechanicsApplication\","
            puts $MyFileVar "            \"Parameters\":    \{"
            puts $MyFileVar "                \"model_part_name\":      \"PorousModelPart.[lindex [lindex $Groups $i] 1]\","
            puts $MyFileVar "                \"variable_name\":        \"$VarName\","
            puts $MyFileVar "                \"is_fixed\":             [lindex [lindex $Groups $i] 8],"
            puts $MyFileVar "                \"value\":                [lindex [lindex $Groups $i] 4],"
            puts $MyFileVar "                \"table\":                [dict get $TableDict [lindex [lindex $Groups $i] 1] Table0],"
            if {[lindex [lindex $Groups $i] 3] eq "Hydrostatic"} {
                set PutStrings true
            } else {
                set PutStrings false
            }
            puts $MyFileVar "                \"hydrostatic\":          $PutStrings,"
            if {[lindex [lindex $Groups $i] 5] eq "Y"} {
                set PutStrings 1
            } elseif {[lindex [lindex $Groups $i] 5] eq "Z"} {
                set PutStrings 2
            } else {
                set PutStrings 0
            }
            puts $MyFileVar "                \"gravity_direction\":    $PutStrings,"
            puts $MyFileVar "                \"reference_coordinate\": [lindex [lindex $Groups $i] 6],"
            puts $MyFileVar "                \"specific_weight\":      [lindex [lindex $Groups $i] 7]"
            puts $MyFileVar "            \}"
            if {$MyGroupNum < $NumGroups} {
                puts $MyFileVar "        \},\{"
            } else {
                puts $MyFileVar "        \}\],"
            }
        }
    }
}

#-------------------------------------------------------------------------------

proc WriteLoadVectorProcess {FileVar GroupNum Groups VarName TableDict NumGroups} {
    upvar $FileVar MyFileVar
    upvar $GroupNum MyGroupNum

    for {set i 0} {$i < [llength $Groups]} {incr i} {
        incr MyGroupNum
        puts $MyFileVar "            \"python_module\": \"apply_vector_constraint_table_process\","
        puts $MyFileVar "            \"kratos_module\": \"KratosMultiphysics.PoromechanicsApplication\","
        puts $MyFileVar "            \"Parameters\":    \{"
        puts $MyFileVar "                \"model_part_name\": \"PorousModelPart.[lindex [lindex $Groups $i] 1]\","
        puts $MyFileVar "                \"variable_name\":   \"$VarName\","
        puts $MyFileVar "                \"active\":          \[[lindex [lindex $Groups $i] 3],[lindex [lindex $Groups $i] 7],[lindex [lindex $Groups $i] 11]\],"
        puts $MyFileVar "                \"value\":           \[[lindex [lindex $Groups $i] 4],[lindex [lindex $Groups $i] 8],[lindex [lindex $Groups $i] 12]\],"
        if {[GiD_AccessValue get gendata Strategy_Type] eq "arc_length"} {
            puts $MyFileVar "                \"table\":           \[0,0,0\]"
        } else {
            puts $MyFileVar "                \"table\":           \[[dict get $TableDict [lindex [lindex $Groups $i] 1] Table0],[dict get $TableDict [lindex [lindex $Groups $i] 1] Table1],[dict get $TableDict [lindex [lindex $Groups $i] 1] Table2]\]"
        }
        puts $MyFileVar "            \}"
        if {$MyGroupNum < $NumGroups} {
            puts $MyFileVar "        \},\{"
        } else {
            puts $MyFileVar "        \}\],"
        }
    }
}

#-------------------------------------------------------------------------------

proc WriteNormalLoadProcess {FileVar GroupNum Groups VarName TableDict NumGroups} {
    upvar $FileVar MyFileVar
    upvar $GroupNum MyGroupNum

    for {set i 0} {$i < [llength $Groups]} {incr i} {
        incr MyGroupNum
        puts $MyFileVar "            \"python_module\": \"apply_normal_load_table_process\","
        puts $MyFileVar "            \"kratos_module\": \"KratosMultiphysics.PoromechanicsApplication\","
        puts $MyFileVar "            \"Parameters\":    \{"
        puts $MyFileVar "                \"model_part_name\":      \"PorousModelPart.[lindex [lindex $Groups $i] 1]\","
        puts $MyFileVar "                \"variable_name\":        \"$VarName\","
        puts $MyFileVar "                \"active\":               \[[lindex [lindex $Groups $i] 3],[lindex [lindex $Groups $i] 11]\],"
        puts $MyFileVar "                \"value\":                \[[lindex [lindex $Groups $i] 5],[lindex [lindex $Groups $i] 12]\],"
        if {[GiD_AccessValue get gendata Strategy_Type] eq "arc_length"} {
            puts $MyFileVar "                \"table\":                \[0,0\],"
        } else {
            puts $MyFileVar "                \"table\":                \[[dict get $TableDict [lindex [lindex $Groups $i] 1] Table0],[dict get $TableDict [lindex [lindex $Groups $i] 1] Table1]\],"
        }
        if {[lindex [lindex $Groups $i] 4] eq "Hydrostatic"} {
            set PutStrings true
        } else {
            set PutStrings false
        }
        puts $MyFileVar "                \"hydrostatic\":          $PutStrings,"
        if {[lindex [lindex $Groups $i] 6] eq "Y"} {
            set PutStrings 1
        } elseif {[lindex [lindex $Groups $i] 6] eq "Z"} {
            set PutStrings 2
        } else {
            set PutStrings 0
        }
        puts $MyFileVar "                \"gravity_direction\":    $PutStrings,"
        puts $MyFileVar "                \"reference_coordinate\": [lindex [lindex $Groups $i] 7],"
        puts $MyFileVar "                \"specific_weight\":      [lindex [lindex $Groups $i] 8]"
        puts $MyFileVar "            \}"
        if {$MyGroupNum < $NumGroups} {
            puts $MyFileVar "        \},\{"
        } else {
            puts $MyFileVar "        \}\],"
        }
    }
}

#-------------------------------------------------------------------------------

proc WriteLoadScalarProcess {FileVar GroupNum Groups VarName TableDict NumGroups} {
    upvar $FileVar MyFileVar
    upvar $GroupNum MyGroupNum

    for {set i 0} {$i < [llength $Groups]} {incr i} {
        incr MyGroupNum
        puts $MyFileVar "            \"python_module\": \"apply_scalar_constraint_table_process\","
        puts $MyFileVar "            \"kratos_module\": \"KratosMultiphysics.PoromechanicsApplication\","
        puts $MyFileVar "            \"Parameters\":    \{"
        puts $MyFileVar "                \"model_part_name\": \"PorousModelPart.[lindex [lindex $Groups $i] 1]\","
        puts $MyFileVar "                \"variable_name\":   \"$VarName\","
        puts $MyFileVar "                \"value\":           [lindex [lindex $Groups $i] 3],"
        if {[GiD_AccessValue get gendata Strategy_Type] eq "arc_length"} {
            puts $MyFileVar "                \"table\":           0"
        } else {
            puts $MyFileVar "                \"table\":           [dict get $TableDict [lindex [lindex $Groups $i] 1] Table0]"
        }
        puts $MyFileVar "            \}"
        if {$MyGroupNum < $NumGroups} {
            puts $MyFileVar "        \},\{"
        } else {
            puts $MyFileVar "        \}\],"
        }
    }
}