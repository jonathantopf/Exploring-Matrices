// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Exploring Matrices/DemoShader"
{
    Properties
    {
    }

    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque" 
            "Queue"="Geometry"
            "DisableBatching"="True"
        }
        
        ZWrite On
        ZTest Less
        Blend One Zero

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 position : POSITION;
                float3 color : COLOR;
                uint id : SV_VertexID;
            };

            struct vertexToFragment
            {
                float4 position : SV_POSITION;
                uint id : TEXCOORD1;
            };

            float4 vertexIdToColor (uint id)
            {
                return float4 (
                   (sin (id) + 1) * 0.5,
                   (sin (id * id) + 1) * 0.5,
                   (sin (id * id * id) + 1) * 0.5,
                   1);
            }

            float4x4 _IdentityMatrix;
            float4x4 _ModelTransformMatrix;
            float4x4 _ViewMatrix;
            float4x4 _ProjectionMatrix;

            float _ModelWeight;
            float _ViewWeight;
            float _ProjectionWeight;

            vertexToFragment vert (appdata vertex)
            {
                vertexToFragment output;

                // This Unity default vertex transformation
                // output.position = UnityObjectToClipPos(vertex.position);

                // Is the same as
                // output.position = mul (UNITY_MATRIX_MVP, vertex.position);

                // You can also split it apart into it's component matrices 
                const float4x4 m = lerp (_IdentityMatrix, _ModelTransformMatrix, _ModelWeight);
                const float4x4 v = lerp (_IdentityMatrix, _ViewMatrix, _ViewWeight);
                const float4x4 p = lerp (_IdentityMatrix, _ProjectionMatrix, _ProjectionWeight);

                output.position = vertex.position;
                output.position = mul (m, output.position);
                output.position = mul (v, output.position);
                output.position = mul (p, output.position);

                // output.position.y += sin (output.position.x + _T);
                // output.position = mul (mul (mul (p, v), m), float4 (vertex.position, 1));
                // output.position.z = -output.position.z;
                output.position = UnityObjectToClipPos (output.position);

                output.id = vertex.id;

                return output;
            }

            fixed4 frag (vertexToFragment input) : SV_Target
            {
                fixed4 output_color = float4 (1,1,1,1);
                output_color *= vertexIdToColor (input.id);

                return output_color;
            }
            ENDCG
        }
    }
}
