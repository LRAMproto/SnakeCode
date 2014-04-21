function Mp = Metric_Tensor(T1, T2)

[Mx1,My1] = gradient(T1);

[Mx2,My2] = gradient(T2);


Mp = [Mx1((length(Mx1)-1)/2) My1((length(My1)-1)/2);Mx2((length(Mx2)-1)/2) My2((length(My2)-1)/2)];