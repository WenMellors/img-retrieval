function param = trainLMH(X, param)%该方法中哈希函数族通过学习得到
m = param.m;
[n dim] = size(X);      
nbits = param.nbits;   %k
max_iter = 30;

sampleMean = mean(X,1);
X = (X - repmat(sampleMean,n,1));%repmat ：堆叠矩阵
C = cov(X);%协方差矩阵
[pc, l] = eigs(C, m);%特征值

for g = 1:nbits
    if(g == 1)
        R = pc(:,1:m);
    else
        R = randn(dim,m);
    end
    %[U S V] = svd(R);
    %R = pc(:,1:m)*U;
    
    for l = 1:m
    	param.w{l}(:,g) = R(:,l)/max(abs(R(:,l)));
    end
    
    iter = 1;
    b = sign(rand(n,1)-0.5);
    obj(1) = -inf;
    while(iter < max_iter)
        for l = 1:m
            e = ones(n,1);    %note: e is array vector which is different fro paper

            for i = 1:m
                if(i ~= l)
                    e = e.*(X*param.w{i}(:,g));
                end
            end
            
            b_old = b;
            y = e.*(X*param.w{l}(:,g));
            b = sign(y);
          
            f = -X'*(e.*b);            
            h = X'*e; 
            
            if(g > 1)
                Aeq = zeros(g-1, dim);
                for i = 1:g-1
                    Aeq(i,:) = param.w{l}(:,i)';
                end                
            else
               Aeq = []; 
            end
            Aeq = [Aeq; h'];

            Beq = zeros(g-1,1);
            Beq = [Beq; 0];

            lb = -ones(dim,1);
            ub = ones(dim,1);

            options=optimset('display','off');
            [wl,u,o,i]=linprog(f,[],[],Aeq,Beq,lb,ub,[],options);
            param.w{l}(:,g) = wl;
        end 
        obj(iter+1) = b'*y;
        %fprintf('iter %d,  %.2e, %.2e\n', iter, norm(b-b_old), obj(iter+1)) ;
        if(abs(obj(iter+1)/obj(iter)-1) < 1e-6)
            break;
        end
        iter = iter + 1;        
    end
end

