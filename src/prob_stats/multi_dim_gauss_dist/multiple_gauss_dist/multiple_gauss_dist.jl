# calculate probability by 
# gaussian distribution pdf
# plot as 2d-contour
# 3 different contours

module MultiGaussDist
    using Plots, Base.Iterators, LinearAlgebra
    pyplot()
    
    function pdf(x, mu, cov_mat)
        # determinant
        det_mat = det(cov_mat)

        diff_x = x - mu
        return exp(-((diff_x'/cov_mat)*diff_x)/2)/(2*pi*sqrt(det_mat))
    end

    function main(is_test=false)
        # x-y grid
        vx = 0:200
        vy = 0:100

        # mu, covariance matrix
        # contour a
        mu_a = [50; 50]
        cov_a = [50 0; 0 100]
        # contour b
        mu_b = [100; 50]
        cov_b = [125 0; 0 25]
        # contour c
        mu_c = [150; 50]
        cov_c = [100 -25*sqrt(3); -25*sqrt(3) 50]

        # probability density
        # contour a
        z_a = [pdf([x; y], mu_a, cov_a) for x in vx, y in vy]
        # contour b
        z_b = [pdf([x; y], mu_b, cov_b) for x in vx, y in vy]
        # contour c
        z_c = [pdf([x; y], mu_c, cov_c) for x in vx, y in vy]

        # plot contours
        contour(vx, vy, z_a', c=:haline, aspect_ratio=:equal)
        contour!(vx, vy, z_b', c=:haline, aspect_ratio=:equal)
        contour!(vx, vy, z_c', c=:haline, aspect_ratio=:equal)
        
        if is_test == false
            save_path = joinpath(split(@__FILE__, "src")[1], "src/prob_stats/multi_dim_gauss_dist/multiple_gauss_dist/multiple_gauss_dist.png")
            savefig(save_path)
        end
    end
end