# License and Copyright {{{
# Copyright (c) 2003 Thomas Hurst <freaky@aagh.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# }}}

# PHP serialize() and unserialize() workalikes
#  First Released: 2003-06-02 (1.0.0)
#  Prev Release: 2003-06-16 (1.0.1), by Thomas Hurst <tom@hur.st>
#  This Release: 2004-09-17 (1.0.2), by Thomas Hurst <tom@hur.st>
#                Switch all {}'s to explicit Hash.new's.
#
#  These two methods should, for the most part, be functionally identical
#  to the respective PHP functions;
#   http://www.php.net/serialize, http://www.php.net/unserialize
#
#
#  string = PHP.serialize(mixed var[, bool assoc])
#   Returns a string representing the argument in a form PHP.unserialize
#   and PHP's unserialize() should both be able to load.
#
#   Array, Hash, Fixnum, Float, True/FalseClass, NilClass, String and Struct
#   are supported; as are objects which support the to_assoc method, which
#   returns an array of the form [['attr_name', 'value']..].  Anything else
#   will raise a TypeError.
#
#   If 'assoc' is specified, Array's who's first element is a two value
#   array will be assumed to be an associative array, and will be serialized
#   as a PHP associative array rather than a multidimensional array.
#
#
#
#  mixed = PHP.unserialize(string serialized, [hash classmap, [bool assoc]])
#   Returns an object containing the reconstituted data from serialized.
#
#   If a PHP array (associative; like an ordered hash) is encountered, it
#   scans the keys; if they're all incrementing integers counting from 0,
#   it's unserialized as an Array, otherwise it's unserialized as a Hash.
#   Note: this will lose ordering.  To avoid this, specify assoc=true,
#   and it will be unserialized as an associative array: [[key,value],...]
#
#   If a serialized object is encountered, the hash 'classmap' is searched for
#   the class name (as a symbol).  Since PHP classnames are not case-preserving,
#   this *must* be a .capitalize()d representation.  The value is expected
#   to be the class itself; i.e. something you could call .new on.
#
#   If it's not found in 'classmap', the current constant namespace is searched,
#   and failing that, a new Struct(classname) is generated, with the arguments
#   for .new specified in the same order PHP provided; since PHP uses hashes
#   to represent attributes, this should be the same order they're specified
#   in PHP, but this is untested.
#
#   each serialized attribute is sent to the new object using the respective
#   {attribute}=() method; you'll get a NameError if the method doesn't exist.
#
#   Array, Hash, Fixnum, Float, True/FalseClass, NilClass and String should
#   be returned identically (i.e. foo == PHP.unserialize(PHP.serialize(foo))
#   for these types); Struct should be too, provided it's in the namespace
#   Module.const_get within unserialize() can see, or you gave it the same
#   name in the Struct.new(<structname>), otherwise you should provide it in
#   classmap.
#
# Note: StringIO is required for unserialize(); it's loaded as needed
#

module PHP

	def self.serialize(var, assoc = false)
		s = ''
		case var
			when Array
				s << "a:#{var.size}:{"
				if assoc and var.first.is_a?(Array) and var.first.size == 2
					var.each { |k,v|
						s << PHP.serialize(k) << PHP.serialize(v)
					}
				else
					var.each_with_index { |v,i|
						s << "i:#{i};#{PHP.serialize(v)}"
					}
				end

				s << '}'

			when Hash
				s << "a:#{var.size}:{"
				var.each do |k,v|
					s << "#{PHP.serialize(k)}#{PHP.serialize(v)}"
				end
				s << '}'

			when Struct
				# encode as Object with same name
				s << "O:#{var.class.to_s.length}:\"#{var.class.to_s.downcase}\":#{var.members.length}:{"
				var.members.each do |member|
					s << "#{PHP.serialize(member)}#{PHP.serialize(var[member])}"
				end
				s << '}'

			when String
				s << "s:#{var.length}:\"#{var}\";"

			when Fixnum # PHP doesn't have bignums
				s << "i:#{var};"

			when Float
				s << "d:#{var};"

			when NilClass
				s << 'N;'

			when FalseClass, TrueClass
				s << "b:#{var ? 1 :0};"

			else
				if var.respond_to?(:to_assoc)
					v = var.to_assoc
					# encode as Object with same name
					s << "O:#{var.class.to_s.length}:\"#{var.class.to_s.downcase}\":#{v.length}:{"
					v.each do |k,v|
						s << "#{PHP.serialize(k.to_s)}#{PHP.serialize(v)}"
					end
					s << '}'
				else
					raise TypeError, "Unable to serialize type #{var.class}"
				end
		end

	end
	
end
