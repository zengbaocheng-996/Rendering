using System.Collections.Generic;
using UnityEngine;
using zClipper;
public class GameManager : MonoBehaviour
{
    public List<Transform> transforms;
    private List<Vector2> points = new List<Vector2>();
    SweepLineSolver solver;
    void Start()
    {
        foreach(Transform t in transforms)
        {
            points.Add(new Vector2(t.position.x, t.position.y));
        }
        solver = new SweepLineSolver(points);
        solver.Solve();
        //SweepLineSolver(points);    
    }
}
