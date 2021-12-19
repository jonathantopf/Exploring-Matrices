using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DemoShaderController : MonoBehaviour
{
    [SerializeField] Camera demoCamera = null;
    [SerializeField] MeshRenderer meshRenderer = null;
    [SerializeField] Shader demoShader = null;
    [Space]
    [SerializeField, Range(0, 1)] float modelWeight = 1;
    [SerializeField, Range(0, 1)] float viewWeight = 1;
    [SerializeField, Range(0, 1)] float projectionWeight = 1;
    
    static readonly int IdentityMatrixProperty = Shader.PropertyToID ("_IdentityMatrix");
    static readonly int ModelTransformMatrixProperty = Shader.PropertyToID ("_ModelTransformMatrix");
    static readonly int ViewMatrixProperty = Shader.PropertyToID ("_ViewMatrix");
    static readonly int ProjectionMatrixProperty = Shader.PropertyToID ("_ProjectionMatrix");

    static readonly int ModelWeightProperty = Shader.PropertyToID ("_ModelWeight");
    static readonly int ViewWeightProperty = Shader.PropertyToID ("_ViewWeight");
    static readonly int ProjectionWeightProperty = Shader.PropertyToID ("_ProjectionWeight");

    Material _demoMaterial;

    Material DemoMaterial
    {
        get
        {
            if (_demoMaterial == null)
            {
                _demoMaterial = new Material(demoShader);
                _demoMaterial.SetMatrix (IdentityMatrixProperty, Matrix4x4.identity);
                meshRenderer.material = _demoMaterial;
            }
            return _demoMaterial;
        }
    }
    
    void Update()
    {
        DemoMaterial.SetMatrix (ModelTransformMatrixProperty, transform.localToWorldMatrix);
        DemoMaterial.SetMatrix (ViewMatrixProperty, demoCamera.worldToCameraMatrix);
        DemoMaterial.SetMatrix (ProjectionMatrixProperty, GL.GetGPUProjectionMatrix(demoCamera.projectionMatrix, false));
        
        DemoMaterial.SetFloat (ModelWeightProperty, modelWeight);
        DemoMaterial.SetFloat (ViewWeightProperty, viewWeight);
        DemoMaterial.SetFloat (ProjectionWeightProperty, projectionWeight);
    }
}
