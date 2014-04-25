#=======================================================================================================================
### Process Definition
begin
  ### Awsome pdef registering ! : )
  BTM.definition :awsome_pdef do

    ### i prefer cursor sequence method in ruote , because it let you control the flow in the easy way : )
    cursor do

      ### if you need inject field datas to workflow presetted... like property or else for case control ^^
      set field: 'field_to_be_injected_to_workflow',
          value: "some_value"

      participant :ref => 'participants_test_test'

    end
  end
end
#=======================================================================================================================