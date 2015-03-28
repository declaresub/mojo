#tag Class
Protected Class Test
	#tag Method, Flags = &h0
		Sub Constructor(className as String, test as Introspection.MethodInfo)
		  self.ClassName = className
		  self.TestMethod = test
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Execute()
		  self.TestMethod.Invoke nil
		  self.Passed = true
		  
		  
		  exception e as RuntimeException
		    if e isA EndException or e isA ThreadEndException then
		      #pragma breakOnExceptions off
		      raise e
		    else
		      self.Passed = false
		      self.Reason = Introspection.GetType(e).Name
		      self.StackTrace = e.Stack
		    end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function GetTests(classList() as Introspection.TypeInfo) As Test()
		  dim tests() as Test
		  
		  for each item as Introspection.TypeInfo in classList
		    for each member as Introspection.MethodInfo in item.GetMethods
		      if IsTestMethod(member) then
		        tests.Append new Test(item.FullName, member)
		      end if
		    next
		  next
		  return tests
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function IsTestMethod(m as Introspection.MethodInfo) As Boolean
		  return InStr(m.Name, TestNamePrefix) = 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function RunTests(testClasses() as Introspection.TypeInfo) As Test()
		  dim testList() as Test = GetTests(testClasses)
		  for each test as Test in testList
		    test.Execute()
		  next
		  return testList
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		ClassName As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return self.className + "." + self.TestMethod.Name
			End Get
		#tag EndGetter
		Name As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Passed As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Reason As String
	#tag EndProperty

	#tag Property, Flags = &h0
		StackTrace() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private TestMethod As Introspection.MethodInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		Shared TestNamePrefix As String = "Test_"
	#tag EndProperty


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
