#tag Module
Protected Module mojo
	#tag Method, Flags = &h0
		Sub Assert(assertion as Boolean, msg as String="")
		  if not assertion then
		    dim e as new AssertionFailure
		    e.Message = msg
		    raise e
		  end if
		End Sub
	#tag EndMethod


	#tag Note, Name = README
		
		mojo is a library of items missing from the Xojo framework. 
		
		
		
		
		Release Notes
		
		2015-03-27 0.0.0.  Initial release, including the mojo.UUID class.
	#tag EndNote


	#tag Constant, Name = Version, Type = String, Dynamic = False, Default = \"0.0.0", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
