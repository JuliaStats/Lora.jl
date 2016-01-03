### BasicMCRange

# BasicMCRange is used for sampling a single parameter via serial Monte Carlo
# It is the most elementary and typical Markov chain Monte Carlo (MCMC) range
# It contains nagivational info (burnin, thinning, number of steps)

immutable BasicMCRange{T<:Int} <: MCRange{T}
  burnin::T
  thinning::T
  nsteps::T
  postrange::StepRange{T, T}
  npoststeps::T

  function BasicMCRange(postrange::StepRange{T, T})
    burnin = first(postrange)-1
    thinning = postrange.step
    nsteps = last(postrange)

    @assert burnin >= 0 "Number of burn-in iterations should be non-negative"
    @assert thinning >= 1 "Thinning should be >= 1"
    @assert nsteps > burnin "Total number of MCMC iterations should be greater than number of burn-in iterations"

    npoststeps = length(postrange)

    new(burnin, thinning, nsteps, postrange, npoststeps)
  end
end

BasicMCRange{T<:Int}(postrange::StepRange{T, T}) = BasicMCRange{T}(postrange)

BasicMCRange{T<:Int}(postrange::UnitRange{T}) = BasicMCRange{T}(first(postrange):1:last(postrange))

BasicMCRange{T<:Int}(; burnin::T=0, thinning::T=1, nsteps::T=100) = BasicMCRange{T}((burnin+1):thinning:nsteps)

Base.writemime(io::IO, ::MIME"text/plain", r::BasicMCRange) =
  print(io, "nsteps = ", repr(r.nsteps), ", burnin = ", repr(r.burnin), ", thinning = ", repr(r.thinning))
