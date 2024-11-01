proc WriteProjectParameters { basename dir problemtypedir TableDict} {

    ## Source auxiliar procedures
    source [file join $problemtypedir ProjectParametersAuxProcs.tcl]

    ## Start ProjectParameters.json file
    set filename [file join $dir ProjectParameters.json]
    set FileVar [open $filename w]

    puts $FileVar "\{"

    ## problem_data
    puts $FileVar "    \"problem_data\": \{"
    puts $FileVar "        \"problem_name\":         \"$basename\","
    puts $FileVar "        \"start_time\":           [GiD_AccessValue get gendata Start_Time],"
    puts $FileVar "        \"end_time\":             [GiD_AccessValue get gendata End_Time],"
    puts $FileVar "        \"echo_level\":           [GiD_AccessValue get gendata Echo_Level],"
    if {[GiD_AccessValue get gendata Initial_Stresses] eq false} {
        puts $FileVar "        \"parallel_type\":        \"[GiD_AccessValue get gendata Parallel_Configuration]\""
    } else {
        puts $FileVar "        \"parallel_type\":        \"[GiD_AccessValue get gendata Parallel_Configuration]\","
        puts $FileVar "        \"initial_stress_utility_settings\":   \{"
        puts $FileVar "            \"mode\":       \"[GiD_AccessValue get gendata Mode]\","
        puts $FileVar "            \"constant_discretization\": [GiD_AccessValue get gendata Constant_Discretization],"
        puts $FileVar "            \"initial_input_filename\":   \"initial_$basename\""
        puts $FileVar "        \}"
    }
    puts $FileVar "    \},"

    ## solver_settings
    puts $FileVar "    \"solver_settings\": \{"
    if {[GiD_AccessValue get gendata Parallel_Configuration] eq "MPI"} {
        puts $FileVar "        \"solver_type\":    \"poromechanics_MPI_U_Pl_Pg_solver\","
    } elseif {[GiD_AccessValue get gendata Solution_Type] eq "explicit"} {
        puts $FileVar "        \"solver_type\":    \"poromechanics_U_Pl_Pg_explicit_dynamic_solver\","
    } else {
        puts $FileVar "        \"solver_type\":    \"poromechanics_U_Pl_Pg_solver\","
    }
    puts $FileVar "        \"model_part_name\":    \"PorousModelPart\","
    puts $FileVar "        \"domain_size\":    [GiD_AccessValue get gendata Domain_Size],"
    puts $FileVar "        \"start_time\":    [GiD_AccessValue get gendata Start_Time],"
    puts $FileVar "        \"time_step\":    [GiD_AccessValue get gendata Delta_Time],"
    puts $FileVar "        \"model_import_settings\":              \{"
    puts $FileVar "            \"input_type\":    \"mdpa\","
    puts $FileVar "            \"input_filename\":    \"$basename\""
    puts $FileVar "        \},"
    puts $FileVar "        \"material_import_settings\": \{"
    puts $FileVar "            \"materials_filename\":    \"PoroMaterials.json\""
    puts $FileVar "        \},"
    if {([GiD_AccessValue get gendata Scheme_Type] eq "cd") || ([GiD_AccessValue get gendata Scheme_Type] eq "ocd") || ([GiD_AccessValue get gendata Scheme_Type] eq "cd_fic")} {
        puts $FileVar "        \"buffer_size\":    3,"
    } else {
        puts $FileVar "        \"buffer_size\":    2,"
    }
    puts $FileVar "        \"echo_level\":    [GiD_AccessValue get gendata Echo_Level],"
    puts $FileVar "        \"clear_storage\":    false,"
    set FLCMGroups [GiD_Info conditions Face_Load_Control_Module groups]
    set NumFLCMGroups [llength $FLCMGroups]
    if {$NumFLCMGroups > 0} {
        puts $FileVar "        \"compute_reactions\":    true,"
    } else {
        puts $FileVar "        \"compute_reactions\":    [GiD_AccessValue get gendata Write_Reactions],"
    }
    puts $FileVar "        \"move_mesh_flag\":    [GiD_AccessValue get gendata Move_Mesh],"
    puts $FileVar "        \"reform_dofs_at_each_step\":    [GiD_AccessValue get gendata Reform_Dofs_At_Each_Step],"
    puts $FileVar "        \"nodal_smoothing\":    [GiD_AccessValue get gendata Nodal_Smoothing],"
    puts $FileVar "        \"gp_to_nodal_variable_list\": \[\],"
    puts $FileVar "        \"gp_to_nodal_variable_extrapolate_non_historical\": false,"
    puts $FileVar "        \"block_builder\":    [GiD_AccessValue get gendata Block_Builder],"
    puts $FileVar "        \"solution_type\":    \"[GiD_AccessValue get gendata Solution_Type]\","
    puts $FileVar "        \"scheme_type\":    \"[GiD_AccessValue get gendata Scheme_Type]\","
    puts $FileVar "        \"newmark_beta\":    [GiD_AccessValue get gendata Newmark_Beta],"
    puts $FileVar "        \"newmark_gamma\":    [GiD_AccessValue get gendata Newmark_Gamma],"
    puts $FileVar "        \"newmark_theta_u\":    [GiD_AccessValue get gendata Newmark_Theta_u],"
    puts $FileVar "        \"newmark_theta_pl\":    [GiD_AccessValue get gendata Newmark_Theta_pl],"
    puts $FileVar "        \"newmark_theta_pg\":    [GiD_AccessValue get gendata Newmark_Theta_pg],"
    if {[GiD_AccessValue get gendata Solution_Type] eq "explicit"} {
         puts $FileVar "        \"theta_factor\":    1.0,"
        puts $FileVar "        \"g_factor\":    [GiD_AccessValue get gendata g_factor],"
         puts $FileVar "        \"calculate_xi\":    [GiD_AccessValue get gendata Calculate_xi],"
          puts $FileVar "        \"xi_1_factor\":    [GiD_AccessValue get gendata xi_1_factor],"
    }
    puts $FileVar "        \"calculate_alpha_beta\":    [GiD_AccessValue get gendata Calculate_Rayleigh_Alpha_Beta],"
    puts $FileVar "        \"omega_1\":    [GiD_AccessValue get gendata omega_1],"
    puts $FileVar "        \"omega_n\":    [GiD_AccessValue get gendata omega_n],"
    puts $FileVar "        \"xi_1\":    [GiD_AccessValue get gendata xi_1],"
    puts $FileVar "        \"xi_n\":    [GiD_AccessValue get gendata xi_n],"
    puts $FileVar "        \"rayleigh_alpha\":    [GiD_AccessValue get gendata Rayleigh_Alpha],"
    puts $FileVar "        \"rayleigh_beta\":    [GiD_AccessValue get gendata Rayleigh_Beta],"
    puts $FileVar "        \"strategy_type\":    \"[GiD_AccessValue get gendata Strategy_Type]\","
    puts $FileVar "        \"convergence_criterion\":    \"[GiD_AccessValue get gendata Convergence_Criterion]\","
    puts $FileVar "        \"displacement_relative_tolerance\":    [GiD_AccessValue get gendata Displacement_Relative_Tolerance],"
    puts $FileVar "        \"displacement_absolute_tolerance\":    [GiD_AccessValue get gendata Displacement_Absolute_Tolerance],"
    puts $FileVar "        \"residual_relative_tolerance\":    [GiD_AccessValue get gendata Residual_Relative_Tolerance],"
    puts $FileVar "        \"residual_absolute_tolerance\":    [GiD_AccessValue get gendata Residual_Absolute_Tolerance],"
    puts $FileVar "        \"max_iteration\":    [GiD_AccessValue get gendata Max_Iterations],"
    puts $FileVar "        \"desired_iterations\":    [GiD_AccessValue get gendata Desired_Iterations],"
    puts $FileVar "        \"max_radius_factor\":    [GiD_AccessValue get gendata Max_Radius_Factor],"
    puts $FileVar "        \"min_radius_factor\":    [GiD_AccessValue get gendata Min_Radius_Factor],"
    if {[GiD_AccessValue get gendata Parallel_Configuration] eq "MPI"} {
        puts $FileVar "        \"nonlocal_damage\":    false,"
    } else {
        puts $FileVar "        \"nonlocal_damage\":    [GiD_AccessValue get gendata Non-local_Damage],"
    }
    puts $FileVar "        \"characteristic_length\":    [GiD_AccessValue get gendata Characteristic_Length],"
    ## linear_solver_settings
    puts $FileVar "        \"linear_solver_settings\":             \{"
    if {[GiD_AccessValue get gendata Parallel_Configuration] eq "MPI"} {
        if {[GiD_AccessValue get gendata Solver_Type] eq "amgcl"} {
            puts $FileVar "            \"solver_type\":   \"amgcl\","
            puts $FileVar "            \"krylov_type\":   \"fgmres\","
            puts $FileVar "            \"max_iteration\": 100,"
            puts $FileVar "            \"verbosity\":     [GiD_AccessValue get gendata Verbosity],"
            puts $FileVar "            \"tolerance\":     1.0e-6,"
            puts $FileVar "            \"scaling\":       [GiD_AccessValue get gendata Scaling]"
        } elseif {[GiD_AccessValue get gendata Solver_Type] eq "aztec"} {
            puts $FileVar "            \"solver_type\":         \"aztec\","
            puts $FileVar "            \"tolerance\":           1.0e-6,"
            puts $FileVar "            \"max_iteration\":       200,"
            puts $FileVar "            \"scaling\":             [GiD_AccessValue get gendata Scaling],"
            puts $FileVar "            \"preconditioner_type\": \"None\""
        } elseif {([GiD_AccessValue get gendata Solver_Type] eq "klu") || ([GiD_AccessValue get gendata Solver_Type] eq "multi_level")} {
            puts $FileVar "            \"solver_type\": \"[GiD_AccessValue get gendata Solver_Type]\","
            puts $FileVar "            \"scaling\":     [GiD_AccessValue get gendata Scaling]"
        } else {
            puts $FileVar "            \"solver_type\": \"klu\","
            puts $FileVar "            \"scaling\":     false"
        }
    } else {
        if {[GiD_AccessValue get gendata Solver_Type] eq "amgcl"} {
            puts $FileVar "            \"solver_type\":     \"amgcl\","
            puts $FileVar "            \"smoother_type\":   \"ilu0\","
            puts $FileVar "            \"krylov_type\":     \"gmres\","
            puts $FileVar "            \"coarsening_type\": \"aggregation\","
            puts $FileVar "            \"max_iteration\":   100,"
            puts $FileVar "            \"verbosity\":       [GiD_AccessValue get gendata Verbosity],"
            puts $FileVar "            \"tolerance\":       1.0e-6,"
            puts $FileVar "            \"scaling\":         [GiD_AccessValue get gendata Scaling]"
        } elseif {[GiD_AccessValue get gendata Solver_Type] eq "bicgstab"} {
            puts $FileVar "            \"solver_type\":         \"bicgstab\","
            puts $FileVar "            \"tolerance\":           1.0e-6,"
            puts $FileVar "            \"max_iteration\":       100,"
            puts $FileVar "            \"scaling\":             [GiD_AccessValue get gendata Scaling],"
            puts $FileVar "            \"preconditioner_type\": \"ilu0\""
        } elseif {([GiD_AccessValue get gendata Solver_Type] eq "skyline_lu_factorization") || ([GiD_AccessValue get gendata Solver_Type] eq "LinearSolversApplication.sparse_lu")} {
            puts $FileVar "            \"solver_type\":   \"[GiD_AccessValue get gendata Solver_Type]\""
        } else {
            puts $FileVar "            \"solver_type\":   \"LinearSolversApplication.sparse_lu\""
        }
    }
    puts $FileVar "        \},"
    ## problem_domain_sub_model_part_list
    set PutStrings \[
    # Body_Part
    AppendGroupNames PutStrings Body_Part
    set PutStrings [string trimright $PutStrings ,]
    append PutStrings \]
    puts $FileVar "        \"problem_domain_sub_model_part_list\": $PutStrings,"
    ## processes_sub_model_part_list
    set PutStrings \[
    # Solid_Displacement
    AppendGroupNames PutStrings Solid_Displacement
    # Liquid_Pressure
    AppendGroupNames PutStrings Liquid_Pressure
    # Gas_Pressure
    AppendGroupNames PutStrings Gas_Pressure
    # Force
    AppendGroupNames PutStrings Force
    # Face_Load
    AppendGroupNames PutStrings Face_Load
    # Face_Load_Control_Module
    AppendGroupNames PutStrings Face_Load_Control_Module
    # Normal_Load
    AppendGroupNames PutStrings Normal_Load
    # Liquid_Discharge
    AppendGroupNames PutStrings Liquid_Discharge
    # Gas_Discharge
    AppendGroupNames PutStrings Gas_Discharge
    # Normal_Liquid_Flux
    AppendGroupNames PutStrings Normal_Liquid_Flux
    # Normal_Gas_Flux
    AppendGroupNames PutStrings Normal_Gas_Flux
    # Body_Acceleration
    AppendGroupNames PutStrings Body_Acceleration
    set PutStrings [string trimright $PutStrings ,]
    append PutStrings \]
    puts $FileVar "        \"processes_sub_model_part_list\":      $PutStrings,"
    ## body_domain_sub_model_part_list
    set PutStrings \[
    AppendGroupNames PutStrings Body_Part
    set PutStrings [string trimright $PutStrings ,]
    append PutStrings \]
    if {[GiD_AccessValue get gendata Strategy_Type] eq "arc_length"} {
        puts $FileVar "        \"body_domain_sub_model_part_list\":    $PutStrings,"
        ## loads_sub_model_part_list
        set PutStrings \[
        set iGroup 0
        # Force
        AppendGroupNamesWithNum PutStrings iGroup Force
        # Face_Load
        AppendGroupNamesWithNum PutStrings iGroup Face_Load
        # Normal_Load
        AppendGroupNamesWithNum PutStrings iGroup Normal_Load
        # Liquid_Discharge
        AppendGroupNamesWithNum PutStrings iGroup Liquid_Discharge
        # Gas_Discharge
        AppendGroupNamesWithNum PutStrings iGroup Gas_Discharge
        # Normal_Liquid_Flux
        AppendGroupNamesWithNum PutStrings iGroup Normal_Liquid_Flux
        # Normal_Gas_Flux
        AppendGroupNamesWithNum PutStrings iGroup Normal_Gas_Flux
        # Body_Acceleration
        AppendGroupNamesWithNum PutStrings iGroup Body_Acceleration
        if {$iGroup > 0} {
            set PutStrings [string trimright $PutStrings ,]
        }
        append PutStrings \]
        puts $FileVar "        \"loads_sub_model_part_list\":          $PutStrings,"
        ## loads_variable_list
        set PutStrings \[
        # Force
        AppendGroupVariables PutStrings Force FORCE
        # Face_Load
        AppendGroupVariables PutStrings Face_Load FACE_LOAD
        # Normal_Load
        AppendGroupVariables PutStrings Normal_Load NORMAL_CONTACT_STRESS
        # Liquid_Discharge
        AppendGroupVariables PutStrings Liquid_Discharge LIQUID_DISCHARGE 
        # Gas_Discharge
        AppendGroupVariables PutStrings Gas_Discharge GAS_DISCHARGE 
        # Normal_Liquid_Flux
        AppendGroupVariables PutStrings Normal_Liquid_Flux NORMAL_LIQUID_FLUX 
        # Normal_Gas_Flux
        AppendGroupVariables PutStrings Normal_Gas_Flux NORMAL_GAS_FLUX
        # Body_Acceleration
        AppendGroupVariables PutStrings Body_Acceleration VOLUME_ACCELERATION
        if {$iGroup > 0} {
            set PutStrings [string trimright $PutStrings ,]
        }
        append PutStrings \]
        puts $FileVar "        \"loads_variable_list\":                $PutStrings"
        puts $FileVar "    \},"
    } else {
        puts $FileVar "        \"body_domain_sub_model_part_list\":    $PutStrings"
        puts $FileVar "    \},"
    }

    ## Output processes
    puts $FileVar "    \"output_processes\": \{"
    puts $FileVar "        \"gid_output\": \[\{"
    puts $FileVar "            \"python_module\": \"gid_output_process\","
    puts $FileVar "            \"kratos_module\": \"KratosMultiphysics\","
    puts $FileVar "            \"process_name\": \"GiDOutputProcess\","
    puts $FileVar "            \"Parameters\":    \{"
    puts $FileVar "                \"model_part_name\": \"PorousModelPart.porous_computational_model_part\","
    puts $FileVar "                \"output_name\": \"$basename\","
    puts $FileVar "                \"postprocess_parameters\": \{"
    puts $FileVar "                    \"result_file_configuration\": \{"
    puts $FileVar "                        \"gidpost_flags\":       \{"
    puts $FileVar "                            \"WriteDeformedMeshFlag\": \"[GiD_AccessValue get gendata Write_deformed_mesh]\","
    puts $FileVar "                            \"WriteConditionsFlag\":   \"[GiD_AccessValue get gendata Write_conditions]\","
    puts $FileVar "                            \"GiDPostMode\":           \"[GiD_AccessValue get gendata GiD_post_mode]\","
    puts $FileVar "                            \"MultiFileFlag\":         \"[GiD_AccessValue get gendata Multi_file_flag]\""
    puts $FileVar "                        \},"
    puts $FileVar "                        \"file_label\":          \"[GiD_AccessValue get gendata File_label]\","
    puts $FileVar "                        \"output_control_type\": \"[GiD_AccessValue get gendata Output_control_type]\","
    puts $FileVar "                        \"output_interval\":    [GiD_AccessValue get gendata Output_interval],"
    puts $FileVar "                        \"body_output\":         [GiD_AccessValue get gendata Body_output],"
    puts $FileVar "                        \"node_output\":         [GiD_AccessValue get gendata Node_output],"
    puts $FileVar "                        \"skin_output\":         [GiD_AccessValue get gendata Skin_output],"
    puts $FileVar "                        \"plane_output\":        \[\],"
    # nodal_results
    set PutStrings \[
    set iGroup 0
    AppendOutputVariables PutStrings iGroup Write_Solid_Displacement DISPLACEMENT
    AppendOutputVariables PutStrings iGroup Write_Liquid_Pressure LIQUID_PRESSURE
    AppendOutputVariables PutStrings iGroup Write_Gas_Pressure GAS_PRESSURE
    AppendOutputVariables PutStrings iGroup Write_Capillary_Pressure CAPILLARY_PRESSURE
    if {[GiD_AccessValue get gendata Write_Reactions] eq true} {
        incr iGroup
        append PutStrings \" REACTION \" , \" REACTION_LIQUID_PRESSURE \" , \" REACTION_GAS_PRESSURE \" ,
    }
    AppendOutputVariables PutStrings iGroup Write_Force FORCE
    AppendOutputVariables PutStrings iGroup Write_Face_Load FACE_LOAD
    AppendOutputVariables PutStrings iGroup Write_Normal_Load NORMAL_CONTACT_STRESS
    AppendOutputVariables PutStrings iGroup Write_Tangential_Load TANGENTIAL_CONTACT_STRESS
    AppendOutputVariables PutStrings iGroup Write_Liquid_Discharge LIQUID_DISCHARGE
    AppendOutputVariables PutStrings iGroup Write_Gas_Discharge GAS_DISCHARGE
    AppendOutputVariables PutStrings iGroup Write_Normal_Liquid_Flux NORMAL_LIQUID_FLUX
    AppendOutputVariables PutStrings iGroup Write_Normal_Gas_Flux NORMAL_GAS_FLUX
    AppendOutputVariables PutStrings iGroup Write_Body_Acceleration VOLUME_ACCELERATION
    if {[GiD_AccessValue get gendata Parallel_Configuration] eq "MPI"} {
        incr iGroup
        append PutStrings \" PARTITION_INDEX \" ,
    }
    # Nodal smoothed variables
    if {[GiD_AccessValue get gendata Nodal_Smoothing] eq true} {
        AppendOutputVariables PutStrings iGroup Write_Effective_Stress NODAL_EFFECTIVE_STRESS_TENSOR
        AppendOutputVariables PutStrings iGroup Write_Joint_Width NODAL_JOINT_WIDTH
        AppendOutputVariables PutStrings iGroup Write_Damage NODAL_JOINT_DAMAGE
    }
    AppendOutputVariables PutStrings iGroup Write_Initial_Stress INITIAL_STRESS_TENSOR
    if {$iGroup > 0} {
        set PutStrings [string trimright $PutStrings ,]
    }
    append PutStrings \]
    puts $FileVar "                        \"nodal_results\":       $PutStrings,"
    # Nodal Non-historical variables
    set PutStrings \[
    set iGroup 0
    set FLCMGroups [GiD_Info conditions Face_Load_Control_Module groups]
    set NumFLCMGroups [llength $FLCMGroups]
    if {$NumFLCMGroups > 0} {
        incr iGroup
        append PutStrings \" AVERAGE_REACTION \" , \" TARGET_REACTION \" , \" LOADING_VELOCITY \" ,
    }
    if {$iGroup > 0} {
        set PutStrings [string trimright $PutStrings ,]
    }
    append PutStrings \]
    puts $FileVar "                        \"nodal_nonhistorical_results\": $PutStrings,"
    # gauss_point_results
    set PutStrings \[
    set iGroup 0
    AppendOutputVariables PutStrings iGroup Write_Strain GREEN_LAGRANGE_STRAIN_TENSOR
    AppendOutputVariables PutStrings iGroup Write_Liquid_Pressure_Gradient LIQUID_PRESSURE_GRADIENT
    AppendOutputVariables PutStrings iGroup Write_Gas_Pressure_Gradient GAS_PRESSURE_GRADIENT
    AppendOutputVariables PutStrings iGroup Write_Liquid_Saturation_Degree LIQUID_SATURATION_DEGREE
    AppendOutputVariables PutStrings iGroup Write_Gas_Saturation_Degree GAS_SATURATION_DEGREE
    AppendOutputVariables PutStrings iGroup Write_Liquid_Relative_Permeability LIQUID_RELATIVE_PERMEABILITY
    AppendOutputVariables PutStrings iGroup Write_Gas_Relative_Permeability GAS_RELATIVE_PERMEABILITY
    AppendOutputVariables PutStrings iGroup Write_Effective_Stress EFFECTIVE_STRESS_TENSOR
    AppendOutputVariables PutStrings iGroup Write_Total_Stress TOTAL_STRESS_TENSOR
    AppendOutputVariables PutStrings iGroup Write_Von_Mises_Stress VON_MISES_STRESS
    AppendOutputVariables PutStrings iGroup Write_Liquid_Flux LIQUID_FLUX_VECTOR
    AppendOutputVariables PutStrings iGroup Write_Gas_Flux GAS_FLUX_VECTOR
    AppendOutputVariables PutStrings iGroup Write_Permeability PERMEABILITY_MATRIX
    AppendOutputVariables PutStrings iGroup Write_Liquid_Permeability LIQUID_PERMEABILITY_MATRIX
    AppendOutputVariables PutStrings iGroup Write_Gas_Permeability GAS_PERMEABILITY_MATRIX
    AppendOutputVariables PutStrings iGroup Write_Damage DAMAGE_VARIABLE
    AppendOutputVariables PutStrings iGroup Write_Joint_Width JOINT_WIDTH
    AppendOutputVariables PutStrings iGroup Write_Contact_Stress_Vector CONTACT_STRESS_VECTOR
    AppendOutputVariables PutStrings iGroup Write_Local_Stress_Vector LOCAL_STRESS_VECTOR
    AppendOutputVariables PutStrings iGroup Write_Local_Relative_Displacement LOCAL_RELATIVE_DISPLACEMENT_VECTOR
    AppendOutputVariables PutStrings iGroup Write_Local_Liquid_Flux LOCAL_LIQUID_FLUX_VECTOR
    AppendOutputVariables PutStrings iGroup Write_Local_Gas_Flux LOCAL_GAS_FLUX_VECTOR
    AppendOutputVariables PutStrings iGroup Write_Local_Permeability LOCAL_PERMEABILITY_MATRIX
    if {$iGroup > 0} {
        set PutStrings [string trimright $PutStrings ,]
    }
    append PutStrings \]
    puts $FileVar "                        \"gauss_point_results\": $PutStrings"
    puts $FileVar "                    \},"
    puts $FileVar "                    \"point_data_configuration\":  \[\]"
    puts $FileVar "                \}"
    puts $FileVar "            \}"
    puts $FileVar "        \}\]"
    puts $FileVar "    \},"

    ## Processes
    puts $FileVar "    \"processes\": \{"
    ## constraints_process_list
    set Groups [GiD_Info conditions Solid_Displacement groups]
    set NumGroups [llength $Groups]
    set Groups [GiD_Info conditions Liquid_Pressure groups]
    incr NumGroups [llength $Groups]
    set Groups [GiD_Info conditions Gas_Pressure groups]
    incr NumGroups [llength $Groups]
    set Groups [GiD_Info conditions Face_Load_Control_Module groups]
    incr NumGroups [llength $Groups]
    set iGroup 0
    puts $FileVar "        \"constraints_process_list\": \[\{"
    # Face_Load_Control_Module
    set Groups [GiD_Info conditions Face_Load_Control_Module groups]
    WriteFaceLoadControlModuleProcess FileVar iGroup $Groups $TableDict $NumGroups
    # Solid_Displacement
    set Groups [GiD_Info conditions Solid_Displacement groups]
    WriteConstraintVectorProcess FileVar iGroup $Groups volumes DISPLACEMENT $TableDict $NumGroups
    WriteConstraintVectorProcess FileVar iGroup $Groups surfaces DISPLACEMENT $TableDict $NumGroups
    WriteConstraintVectorProcess FileVar iGroup $Groups lines DISPLACEMENT $TableDict $NumGroups
    WriteConstraintVectorProcess FileVar iGroup $Groups points DISPLACEMENT $TableDict $NumGroups
    # Note: it is important to write processes in the following order to account for intersections between conditions
    # Liquid_Pressure
    set Groups [GiD_Info conditions Liquid_Pressure groups]
    WritePressureConstraintProcess FileVar iGroup $Groups volumes LIQUID_PRESSURE $TableDict $NumGroups
    WritePressureConstraintProcess FileVar iGroup $Groups surfaces LIQUID_PRESSURE $TableDict $NumGroups
    WritePressureConstraintProcess FileVar iGroup $Groups lines LIQUID_PRESSURE $TableDict $NumGroups
    WritePressureConstraintProcess FileVar iGroup $Groups points LIQUID_PRESSURE $TableDict $NumGroups
    # Gas_Pressure
    set Groups [GiD_Info conditions Gas_Pressure groups]
    WritePressureConstraintProcess FileVar iGroup $Groups volumes GAS_PRESSURE $TableDict $NumGroups
    WritePressureConstraintProcess FileVar iGroup $Groups surfaces GAS_PRESSURE $TableDict $NumGroups
    WritePressureConstraintProcess FileVar iGroup $Groups lines GAS_PRESSURE $TableDict $NumGroups
    WritePressureConstraintProcess FileVar iGroup $Groups points GAS_PRESSURE $TableDict $NumGroups
    ## loads_process_list
    set Groups [GiD_Info conditions Force groups]
    set NumGroups [llength $Groups]
    set Groups [GiD_Info conditions Face_Load groups]
    incr NumGroups [llength $Groups]
    set Groups [GiD_Info conditions Normal_Load groups]
    incr NumGroups [llength $Groups]
    set Groups [GiD_Info conditions Liquid_Discharge groups]
    incr NumGroups [llength $Groups]
    set Groups [GiD_Info conditions Gas_Discharge groups]
    incr NumGroups [llength $Groups]
    set Groups [GiD_Info conditions Normal_Liquid_Flux groups]
    incr NumGroups [llength $Groups]
    set Groups [GiD_Info conditions Normal_Gas_Flux groups]
    incr NumGroups [llength $Groups]
    set Groups [GiD_Info conditions Body_Acceleration groups]
    incr NumGroups [llength $Groups]
    if {$NumGroups > 0} {
        set iGroup 0
        puts $FileVar "        \"loads_process_list\": \[\{"
        # Force
        set Groups [GiD_Info conditions Force groups]
        WriteLoadVectorProcess FileVar iGroup $Groups FORCE $TableDict $NumGroups
        # Face_Load
        set Groups [GiD_Info conditions Face_Load groups]
        WriteLoadVectorProcess FileVar iGroup $Groups FACE_LOAD $TableDict $NumGroups
        # Normal_Load
        set Groups [GiD_Info conditions Normal_Load groups]
        WriteNormalLoadProcess FileVar iGroup $Groups NORMAL_CONTACT_STRESS $TableDict $NumGroups
        # Liquid_Discharge
        set Groups [GiD_Info conditions Liquid_Discharge groups]
        WriteLoadScalarProcess FileVar iGroup $Groups LIQUID_DISCHARGE $TableDict $NumGroups
        # Gas_Discharge
        set Groups [GiD_Info conditions Gas_Discharge groups]
        WriteLoadScalarProcess FileVar iGroup $Groups GAS_DISCHARGE $TableDict $NumGroups
        # Normal_Liquid_Flux
        set Groups [GiD_Info conditions Normal_Liquid_Flux groups]
        WriteLoadScalarProcess FileVar iGroup $Groups NORMAL_LIQUID_FLUX $TableDict $NumGroups
        # Normal_Gas_Flux
        set Groups [GiD_Info conditions Normal_Gas_Flux groups]
        WriteLoadScalarProcess FileVar iGroup $Groups NORMAL_GAS_FLUX $TableDict $NumGroups
        # Body_Acceleration
        set Groups [GiD_Info conditions Body_Acceleration groups]
        WriteLoadVectorProcess FileVar iGroup $Groups VOLUME_ACCELERATION $TableDict $NumGroups
    } else {
        puts $FileVar "        \"loads_process_list\":       \[\],"
    }
    ## auxiliar_process_list
    set NumGroups 0
    puts $FileVar "        \"auxiliar_process_list\": \[\]"

    puts $FileVar "    \}"
    puts $FileVar "\}"

    close $FileVar
}
