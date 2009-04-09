module Rojam
  class InstructionParser
    include Opcode

    class << self
      {
        :no_arg       => 1,
        :var          => 2,
        :implicit_var => 1,
        :ldc          => 2,
        :ldc_w        => 3,
        :label        => 3,
        :method       => 3,
        :field        => 3,
        :int          => 2,
        :iinc         => 3,
        :type         => 3,
        :lookup_switch  => -1
      }.each do |type, size|
        class_eval %Q{
          def #{type}_instructions(*opcode, &block)
            instructions(#{size}, *opcode, &block)
          end
        }
      end

      def instructions(consumed_byte_size, *opcode, &block)
        opcode.each do |single_bytecode|
          define_method instruction_method_name(single_bytecode), &block
          consumed_byte_size_table[single_bytecode] = consumed_byte_size
        end
      end

      def instruction_method_name(instruction_code)
        "__#{instruction_code}__"
      end

      def consumed_byte_size(bytecode)
        consumed_byte_size_table[bytecode]
      end

      private
      def consumed_byte_size_table
        @consumed_byte_size ||= {}
      end
    end

    def initialize constant_pool, labels
      @pool = constant_pool
      @labels = labels
    end
    
    def parse(node, bytes)
      current = 0
      
      while (current < bytes.size)
        instruction, consumed_size = parse_instruction(bytes[current..-1], current)
        node.instructions << instruction
        current += (consumed_size || InstructionParser.consumed_byte_size(bytes[current]))
      end
    end

    def parse_instruction(bytes, current = 0)
      method_name = InstructionParser.instruction_method_name(bytes[0])
      raise "Instruction #{bytes[0]}(0x%x) can not be parsed" % bytes[0] unless self.respond_to?(method_name)
      self.send(method_name, bytes, current)
    end
    
    private
    method_instructions(INVOKESPECIAL, INVOKEVIRTUAL) do |bytes, current|
      owner_index = bytes[1..2].to_unsigned
      owner_name = @pool.method_owner_name(owner_index)
      name, desc = @pool.name_and_desc(owner_index)
      MethodInsn.new(bytes[0], owner_name, name, desc)
    end

    no_arg_instructions(NOP,
      ACONST_NULL,
      ICONST_M1, ICONST_0, ICONST_1, ICONST_2, ICONST_3, ICONST_4, ICONST_5,
      LCONST_0, LCONST_1,
      IALOAD, IASTORE,
      AALOAD, AASTORE,
      IADD, ISUB, IMUL, IDIV,
      LADD, LSUB, LMUL, LDIV,
      DUP,
      RETURN, IRETURN, LRETURN, ARETURN,
      ARRAYLENGTH,
      ATHROW
    ) do |bytes, current|
      Instruction.new(bytes[0])
    end

    field_instructions(GETSTATIC, GETFIELD) do |bytes, current|
      owner_index = bytes[1..2].to_unsigned
      owner_name = @pool.method_owner_name(owner_index)
      name, desc = @pool.name_and_desc(owner_index)
      FieldInsn.new(bytes[0], owner_name, name, desc)
    end

    ldc_instructions(LDC) do |bytes, current|
      LdcInsn.new(bytes[0], @pool.value(bytes[1]))
    end

    ldc_w_instructions(LDC_W, LDC2_W) do |bytes, current|
      LdcInsn.new(bytes[0], @pool.value(bytes[1..2].to_unsigned))
    end

    label_instructions(IF_ICMPNE, IF_ICMPGE, GOTO) do |bytes, current|
      offset = bytes[1..2].to_unsigned
      JumpInsn.new(bytes[0], @labels[current + offset])
    end

    int_instructions(BIPUSH, NEWARRAY) do |bytes, current|
      IntInsn.new(bytes[0], bytes[1])
    end

    iinc_instructions(IINC) do |bytes, current|
      IincInsn.new(bytes[0], bytes[1], bytes[2])
    end

    var_instructions(ISTORE, ILOAD, LSTORE, LLOAD, ASTORE, ALOAD) do |bytes, current|
      VarInsn.new(bytes[0], bytes[1])
    end

    implicit_var_instructions(ISTORE_0, ISTORE_1, ISTORE_2, ISTORE_3) do |bytes, current|
      VarInsn.new(ISTORE, (bytes[0] - ISTORE_0))
    end

    implicit_var_instructions(LSTORE_0, LSTORE_1, LSTORE_2, LSTORE_3) do |bytes, current|
      VarInsn.new(LSTORE, (bytes[0] - LSTORE_0))
    end

    implicit_var_instructions(ASTORE_0, ASTORE_1, ASTORE_2, ASTORE_3) do |bytes, current|
      VarInsn.new(ASTORE, (bytes[0] - ASTORE_0))
    end

    implicit_var_instructions(ILOAD_0, ILOAD_1, ILOAD_2, ILOAD_3) do |bytes, current|
      VarInsn.new(ILOAD, (bytes[0] - ILOAD_0))
    end

    implicit_var_instructions(LLOAD_0, LLOAD_1, LLOAD_2, LLOAD_3) do |bytes, current|
      VarInsn.new(LLOAD, (bytes[0] - LLOAD_0))
    end

    implicit_var_instructions(ALOAD_0, ALOAD_1, ALOAD_2, ALOAD_3) do |bytes, current|
      VarInsn.new(ALOAD, (bytes[0] - ALOAD_0))
    end

    type_instructions(NEW, ANEWARRAY) do |bytes, current|
      type = @pool.type_name(bytes[1..2].to_unsigned)
      TypeInsn.new(bytes[0], type)
    end

    def create_case_table(bytes, current)
      pairs_size = bytes[5..8].to_unsigned
      case_current = 9
      case_table = {}
      pairs_size.times do
        case_value = bytes[case_current..(case_current + 3)].to_unsigned
        case_offset = bytes[(case_current + 4)..(case_current + 7)].to_unsigned
        case_table[case_value] = @labels[current + case_offset]
        case_current += 8
      end
      case_table
    end

    #TODO fix padding problem
    lookup_switch_instructions(LOOKUPSWITCH) do |bytes, current|
      default_offset = bytes[1..4].to_unsigned
      case_table = create_case_table(bytes, current)
      insn = LookupSwitchInsn.new(bytes[0], @labels[current + default_offset], case_table)
      [insn, 9 + case_table.size * 8]
    end
  end
end