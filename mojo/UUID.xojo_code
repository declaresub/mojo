#tag Class
Protected Class UUID
	#tag Method, Flags = &h0
		Sub Constructor()
		  //creates a fresh, new v4 UUID.
		  self.data = Generate
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function Generate() As uuid_t
		  #if TargetMacOS
		    declare sub uuid_generate lib macos.libc (ByRef out as uuid_t)
		    
		    dim data as uuid_t
		    uuid_generate(data)
		    return data
		  #endif
		  
		  #if targetLinux
		    declare sub uuid_generate lib linux.libc (ByRef out as uuid_t)
		    
		    dim data as uuid_t
		    uuid_generate(data)
		    return data
		  #endif
		  
		  #if targetWin32
		    soft declare function UuidCreate lib win32.Rpcrt4 (ByRef Uuid as uuid_t) as Integer
		    dim data as uuid_t
		    dim err as Integer = UuidCreate(data)
		    return data
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Null() As uuid
		  static nullUUID as UUID = "00000000-0000-0000-0000-000000000000"
		  return nullUUID
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(u2 as UUID) As Integer
		  #if TargetMacOS
		    declare function uuid_compare lib macos.libc (ByRef uu1 as uuid_t, ByRef uu2 as uuid_t) as Integer
		    declare function uuid_is_null lib macos.libc (ByRef uu as uuid_t) as Integer
		    dim myData as uuid_t = self.data
		    if u2 is nil then
		      return If(uuid_is_null(myData) = 1, 0, 1)
		    else
		      dim u2_data as uuid_t = u2.data
		      return uuid_compare(myData, u2_data)
		    end if
		  #endif
		  
		  #if  targetLinux
		    declare function uuid_compare lib linux.libc (ByRef uu1 as uuid_t,ByRef uu2 as uuid_t) as Integer
		    declare function uuid_is_null lib linux.libc (ByRef uu as uuid_t) as Integer
		    dim myData as uuid_t = self.data
		    if u2 is nil then
		      return If(uuid_is_null(myData) = 1, 0, 1)
		    else
		      dim u2_data as uuid_t = u2.data
		      return uuid_compare(myData, u2_data)
		    end if
		  #endif
		  
		  #if targetWin32
		    declare function UuidCompare lib win32.Rpcrt4 (ByRef Uuid1 as uuid_t, ByRef Uuid2 as uuid_t, ByRef status as Integer) as Integer
		    declare function UuidIsNil lib win32.Rpcrt4 (ByRef uu as uuid_t, ByRef status as Integer) as Boolean
		    
		    dim result as Integer
		    dim myData as uuid_t = self.data
		    if u2 is nil then
		      return If(UuidIsNil(myData, result), 0, 1)
		    else
		      dim u2_data as uuid_t = u2.data
		      return UuidCompare(myData, u2_data, result)
		    end if
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Convert() As String
		  #if targetMacOS
		    declare sub uuid_unparse lib macos.libc (ByRef u as uuid_t, out as Ptr)
		    
		    dim data as uuid_t = self.data
		    dim m as new MemoryBlock(37)
		    uuid_unparse(data, m)
		    return DefineEncoding(m, Encodings.ASCII)
		  #endif
		  
		  #if targetLinux
		    declare sub uuid_unparse lib linux.libc (ByRef u as uuid_t, out as Ptr)
		    
		    dim data as uuid_t = self.data
		    dim m as new MemoryBlock(37)
		    uuid_unparse(data, m)
		    return DefineEncoding(m, Encodings.ASCII)
		  #endif
		  
		  #if targetWin32
		    soft declare function UuidToStringA lib win32.Rpcrt4 (ByRef Uuid as uuid_t, ByRef StringUuid as Ptr) as Integer
		    
		    dim stringuuid as Ptr
		    dim value as String
		    dim myData as uuid_t = self.data
		    dim err as Integer = UuidToStringA(myData, stringuuid)
		    if err = 0 then
		      try
		        dim m as MemoryBlock = stringuuid
		        value = DefineEncoding(m.CString(0), Encodings.ASCII)
		      finally
		        soft declare function RpcStringFreeA lib win32.Rpcrt4 (ByRef p as Ptr) as Integer
		        dim freeErr as Integer = RpcStringFreeA(stringuuid)
		      end try
		    else
		      //
		    end if
		    return value
		  #endif
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Operator_Convert(value as String)
		  if value.Encoding <> nil then
		    value = ConvertEncoding(value, Encodings.ASCII)
		  end if
		  
		  // if value is 32 hex digits, then I'll presume that it is a uuid value.
		  if value.LenB = 32 then
		    dim r as new RegEx
		    r.SearchPattern = "[0-9a-fA-F]{32,32}"
		    dim match as RegExMatch = r.Search(value)
		    if match <> nil then
		      value = Join(Array(Mid(value, 1, 8), Mid(value, 9, 4), Mid(value, 13, 4), Mid(value, 17, 4), Mid(value, 21, 12)), "-")
		    end if
		  end if
		  
		  
		  #if targetMacOS
		    declare function uuid_parse lib macos.libc (inValue as CString, ByRef uu as uuid_t) as Integer
		    
		    dim data as uuid_t
		    if uuid_parse(value, data) = 0 then
		      self.data = data
		    else
		      raise new RuntimeException
		    end if
		  #endif
		  
		  #if targetLinux
		    declare function uuid_parse lib linux.libc (inValue as CString, ByRef uu as uuid_t) as Integer
		    
		    dim data as uuid_t
		    if uuid_parse(value, data) = 0 then
		      self.data = data
		    else
		      raise new RuntimeException
		    end if
		  #endif
		  
		  #if targetWin32
		    soft declare function UuidFromStringA lib win32.Rpcrt4 (StringUuid as CString, ByRef uuid as uuid_t) as Integer
		    
		    dim data as uuid_t
		    dim err as Integer = UuidFromStringA(value, data)
		    if err = 0 then
		      self.data = data
		    else
		      raise new RuntimeException
		    end if
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_CompareEqual()
		  dim u as new UUID
		  dim s as String = u
		  dim u2 as UUID = s
		  assert u = u2, "UUIDs with equal value should compare to equal."
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_NullsNil()
		  assert UUID.Null = nil, "Null UUID should equal nil."
		End Sub
	#tag EndMethod


	#tag Note, Name = ReadMe
		mojo.UUID is a class that represents UUIDs as immutable value objects. 
		
		
		UUID Creation
		
		Create a new (Version 4) UUID:
		
		dim u as new mojo.UUID
		
		Create a UUID object from a string:
		
		dim u as mojo.UUID = "1b4e28ba-2fa1-11d2-883f-b9a76"
		
		or 
		
		dim u as mojo.UUID = "1b4e28ba2fa111d2883fb9a76"
		
		Get the null UUID:
		
		dim nullUUID as mojo.UUID = mojo.UUID.Null
		
		
		//UUID Manipulation
		
		Get a formatted string:
		
		dim s as String = theUUID
		
		Get raw data.
		
		dim bytes as String = theUUID.Data
		
		
		An Operator_Compare function allows for comparision of UUID objects by lexicographic order.  
		Two mojo.UUID objects having the same value are deemed to be equal.
		mojo.UUID.Null = nil.
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return self.data.StringValue(true)
			End Get
		#tag EndGetter
		Bytes As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private data As uuid_t
	#tag EndProperty


	#tag Structure, Name = uuid_t, Flags = &h21
		x(15) as uint8
	#tag EndStructure


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
End Class
#tag EndClass
