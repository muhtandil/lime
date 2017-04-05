package lime.graphics.opengl;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.GLUniformLocation;

/**
 * ...
 * @author muhtandil
 */
typedef Viewport = {
	x:Int,y:Int,sx:Int,sy:Int,
};

class GLState 
{
	public static var glTexToNum:Map<Int,Int> = null;
	
	public var program:GLProgram;
	public var framebuffer:GLFramebuffer;
	public var vertexBuffer:GLBuffer;
	public var indexBuffer:GLBuffer;
	//public var stencilMask:Int;
	public var activatedTexture:Null<Int>;
	
	public var glTextures:Array<Null<GLTexture>>;
	public var uniformTextures:Array<Null<GLUniformLocation>>;
	
	public var depth:Null<Bool>;
	public var stencil:Null<Bool>;
	public var blend:Null<Bool>;
	
	public var blendSFactor:Int;
	public var blendDFactor:Int;
	public var blendEquationMode:Int;
	
	public var vertexAttribArrays:Array<Null<Bool>>;
	public function new() 
	{
		if (glTexToNum == null){
			glTexToNum = new Map<Int,Int>();
			glTexToNum.set(GL.TEXTURE0, 0);
			glTexToNum.set(GL.TEXTURE1, 1);
			glTexToNum.set(GL.TEXTURE2, 2);
			glTexToNum.set(GL.TEXTURE3, 3);
			glTexToNum.set(GL.TEXTURE4, 4);
			glTexToNum.set(GL.TEXTURE5, 5);
			glTexToNum.set(GL.TEXTURE6, 6);
			glTexToNum.set(GL.TEXTURE7, 7);
			glTexToNum.set(GL.TEXTURE8, 8);
			glTexToNum.set(GL.TEXTURE9, 9);
			glTexToNum.set(GL.TEXTURE10, 10);
			glTexToNum.set(GL.TEXTURE11, 11);
			glTexToNum.set(GL.TEXTURE12, 12);
			glTexToNum.set(GL.TEXTURE13, 13);
			glTexToNum.set(GL.TEXTURE14, 14);
		}
		activatedTexture = null;
		depth = null;
		stencil = null;
		blend = null;
		framebuffer = null;
		glTextures = new Array<Null<GLTexture>>();
		uniformTextures = new Array<Null<GLUniformLocation>>();
		vertexAttribArrays = new Array<Null<Bool>>();
		blendDFactor = 0;
		blendSFactor = 0;
		blendEquationMode = 0;
	}
	public inline function enableVertexAttribArray(index:Int):Void{
		setArrayLength(vertexAttribArrays, index + 1);
		vertexAttribArrays[index] = true;
	}
	public inline function disableVertexAttribArray(index:Int):Void{
		setArrayLength(vertexAttribArrays, index + 1);
		vertexAttribArrays[index] = false;
	}	
	public inline function blendEquation (mode:Int):Void{
		blendEquationMode = mode;
	}
	public inline function blendFunc(sfactor:Int, dfactor:Int):Void{
		blendDFactor = dfactor;
		blendSFactor = sfactor;
	}
	public function copyTo(st:GLState):Void{
		st.depth = this.depth;
		st.stencil = this.stencil;
		st.blend = this.blend;
		st.blendDFactor = blendDFactor;
		st.blendSFactor = blendSFactor;
		st.blendEquationMode = blendEquationMode;
		st.framebuffer = framebuffer;
		st.activatedTexture = activatedTexture;
		st.program = program;
		st.uniformTextures = uniformTextures;
		st.glTextures = glTextures;
		st.vertexAttribArrays = vertexAttribArrays;
	}
	public inline function enable(cap:Int):Void{
		if (cap == GL.DEPTH_TEST) depth = true;
		else if (cap == GL.BLEND) blend = true;
		else if (cap == GL.STENCIL_TEST) stencil = true;
	}
	public inline function disable(cap:Int):Void{
		if (cap == GL.DEPTH_TEST) depth = false;
		else if (cap == GL.BLEND) blend = false;
		else if (cap == GL.STENCIL_TEST) stencil = false;		
	}
	public function bindBuffer (target:Int, buffer:GLBuffer):Void {
		if (target == GL.ARRAY_BUFFER){
			vertexBuffer = buffer;
		}else if(target == GL.ELEMENT_ARRAY_BUFFER){
			indexBuffer = buffer;
		}else{
			trace("Bind some unknown buffer", target);
		}
	}
	public inline function activeTexture(texture:Int):Void{
		activatedTexture = glTexToNum.get(texture);
	}
	public inline function uniform1i(uniform:GLUniformLocation, index:Int):Void{
		//if (glTextures[i] != null){
			setArrayLength(uniformTextures, index);	
			uniformTextures[index] = uniform;
		//}
	}
	public inline function bindTexture(target:Int, texture:GLTexture):Void{
		if(activatedTexture!= null && target == GL.TEXTURE_2D){
			var nPos:Int = glTexToNum.get(activatedTexture);
			setArrayLength(glTextures,nPos);
			glTextures[nPos] = texture;
		}
	}
	public function setArrayLength<T>(ar:Array<Null<T>>,pos:Int):Void{
		if (pos >= ar.length){
			for (i in 0... pos - ar.length){
				ar.push(null);
			}
		}
	}
	public inline function useProgram(p:GLProgram):Void{
		if (program != p){
			program = p;
			clearTextures();
		}
	}
	public inline function clearTextures():Void{
		for (i in 0...glTextures.length){
			glTextures[i]=null;
		}
	}
	public function toString():String{
		return "Depth: " + depth + " Stencil: " + stencil + "Blend: " + blend;
	}
	
}